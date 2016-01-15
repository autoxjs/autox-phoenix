`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import startApp from '../../tests/helpers/start-app'`

module 'Acceptance: SessionCookie',
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
      email: "test@test.test"
      password: "password123"
    Cookies.remove "remember-token"
    Cookies.remove "_dummy_key"
    return

  afterEach: ->
    Ember.run @application, 'destroy'

test 'visiting /', (assert) ->
  visit '/'

  andThen =>
    @session.logout() if @session.get('loggedIn')

  andThen =>
    assert.equal @session.get("cookieKey"), "_dummy_key"
    @session.login @userParams

  andThen =>
    assert.ok @session.get("loggedIn"), "we should be logged in"
    @oldCookie = Cookies.get("_dummy_key")
    assert.ok @oldCookie
    assert.equal @oldCookie, @session.get("cookie")
    @owner = @store.createRecord "owner",
      name: "Daryl Hammond"
    @owner.save()

  andThen =>
    @session.update owner: @owner

  andThen =>
    @store.findAll "taco"
    .then (tacos) ->
      assert.ok tacos, "we should be able to access auth stuff"
    .catch (errors) ->
      assert.notOk errors, "we should not get here"

  andThen =>
    @session
    .get("model")
    .reload()
    .then (session) =>
      session.get("owner")
    .then (owner) =>
      assert.ok owner
      assert.ok owner.get('id')
      assert.ok @oldCookie
      assert.notEqual @oldCookie, Cookies.get("_dummy_key"), "should have changed the cookie"
