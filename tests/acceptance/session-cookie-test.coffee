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
    return

  afterEach: ->
    Ember.run @application, 'destroy'

test 'visiting /', (assert) ->
  visit '/'

  andThen =>
    @session.logout() if @session.get('loggedIn')

  andThen =>
    @session.login @userParams

  andThen =>
    assert.ok @session.get("loggedIn"), "we should be logged in"
    @store.findAll "taco"
    .then (tacos) ->
      assert.ok tacos, "we should be able to access auth stuff"
    .catch (errors) ->
      assert.notOk errors, "we should not get here"
