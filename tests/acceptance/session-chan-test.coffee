`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import startApp from '../../tests/helpers/start-app'`

module 'Acceptance: SessionChan',
  beforeEach: ->
    @application = startApp()
    ###
    Don't return anything, because QUnit looks for a .then
    that is present on Ember.Application, but is deprecated.
    ###
    @store = @application.__container__.lookup("service:store")
    @session = @application.__container__.lookup("service:session")
    @socket = @application.__container__.lookup("service:socket")
    @userParams =
      email: "acceptance-session-#{Math.random()}@test.co"
      password: "password123"
    Cookies.remove "remember-token"
    return

  afterEach: ->
    Ember.run @application, 'destroy'

test 'visiting /', (assert) ->
  visit '/'

  andThen =>
    @user = @store.createRecord "user", @userParams
    @user.save()
  
  andThen =>
    assert.notOk @session.get("loggedIn")
    assert.ok @user.get("id"), "user id should be present"
    @session.on "login", ->
      @set "testLoginFlag", true
    @session.on "change", ->
      @set "testChangeFlag", true
    @session.login @userParams
  
  andThen =>
    assert.ok @session.get("model.isValid"), "should not have errors"
    assert.equal @session.get("loggedIn"), true, "we should be logged in"
    assert.ok @session.get("model.rememberToken"), "session token should be present"
    assert.equal Cookies.get("remember-token"), @session.get("model.rememberToken"), "session token should match"
    assert.equal @session.get("testLoginFlag"), true, "login event should have been called"
    assert.notEqual @session.get("testChangeFlag"), true, "change event should not be fired"

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
    @taco = @store.createRecord "taco",
      name: "steak al pastor"
      calories: 666
    @taco.save()

  andThen =>
    assert.ok @chan.tacoTestCtn.flag, true, "the server should have beamed down the broadcast"
    assert.ok @taco.id
    assert.equal @taco.get("name"), "steak al pastor"
    assert.equal @taco.get("calories"), 666
    @taco.destroyRecord()

  andThen =>
    assert.equal @chan.tacoTestCtn.kill, true
    assert.notOk @store.peekRecord "taco", @taco.id

    @session.destroyModel()

  andThen =>
    assert.notOk @session.get("loggedIn"), "we should be logged out"
    assert.equal @socket.get("state"), "disconnected", "we should be disconnected from the socket"
    assert.ok @chan.get("isDisconnected"), "we should be disconnected from the channel"