`import Ember from 'ember'`
`import { test } from 'qunit'`
`import moduleForAcceptance from '../../tests/helpers/module-for-acceptance'`
{RSVP} = Ember
moduleForAcceptance 'Acceptance: SessionChan'

test 'visiting /', (assert) ->
  @store = @application.__container__.lookup("service:store")
  @session = @application.__container__.lookup("service:autox-session-context")
  @socket = @application.__container__.lookup("service:socket")
  @userParams =
    email: "acceptance-session-#{Math.random()}@test.co"
    password: "password123"
  visit '/'

  andThen =>
    @shop = @store.createRecord "shop",
      name: "jackson Davis Shop"
      location: "nowhere"
    @user = @store.createRecord "user", @userParams
    RSVP.all [@user.save(), @shop.save()]
  
  andThen =>
    assert.ok @shop.get("id"), "shop should be ok"
    assert.notOk @session.get("loggedIn")
    assert.ok @user.get("id"), "user id should be present"
    @session.on "login", ->
      @set "testLoginFlag", true
    @session.login @userParams
  
  andThen =>
    assert.ok @session.get("loggedIn"), "we should be logged in"
    assert.ok @session.get("model.rememberToken"), "session token should be present"
    assert.equal @session.get("testLoginFlag"), true, "login event should have been called"

    @store.findRecord "session", @session.get("model.id")
    .then (session) =>
      assert.ok session
      assert.equal session.get("id"), @session.get("model.id")
  andThen =>
    @socket.connect()

  andThen =>
    @chan = @session.channelFor "user"
    assert.ok @chan, "we should find the channel"
    assert.ok @chan instanceof Ember.Service, "the channel should be what we expected"
    assert.equal typeof @chan.makeTopic, 'function', "the channel should have the chan core"
    assert.equal typeof @chan.connect, 'function', "the channel should have the chan core"

    @session.connect "user"

  andThen =>
    assert.equal @chan.get("isConnected"), true, "we should be channel connected"
    @chan.tacoTestCtn = {}
    @chan.on "update", (data) ->
      @tacoTestCtn.data = data
      @tacoTestCtn.flag = true
    @chan.on "destroy", ->
      @tacoTestCtn.kill = true
    @owner = @store.createRecord "owner", name: "death 2 sessions"
    @owner.save()

  andThen =>
    @session.update {@owner}

  andThen =>
    @taco = @store.createRecord "taco",
      name: "steak al pastor"
      calories: 666
    @taco.save()

  andThen =>
    @refreshFlag = false
    @chan.on "refresh", ({type, id}) =>
      assert.equal type, "tacos"
      assert.equal id, @taco.get("id")
      @refreshFlag = true
    @taco.relate "shops"
    .associate @shop
    .save()

  andThen =>
    assert.ok @refreshFlag, "we should have received an order to refresh"
    assert.ok @chan.tacoTestCtn.flag, "the server should have beamed down the broadcast"
    assert.ok @taco.id
    assert.equal @taco.get("name"), "steak al pastor"
    assert.equal @taco.get("calories"), 666

    @session.logout()

  andThen =>
    assert.notOk @session.get("loggedIn"), "we should be logged out"
    assert.equal @socket.get("state"), "disconnected", "we should be disconnected from the socket"
    assert.ok @chan.get("isDisconnected"), "we should be disconnected from the channel"