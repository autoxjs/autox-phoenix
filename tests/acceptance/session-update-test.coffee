`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import startApp from '../../tests/helpers/start-app'`

module 'Acceptance: SessionUpdate',
  beforeEach: ->
    @application = startApp()
    ###
    Don't return anything, because QUnit looks for a .then
    that is present on Ember.Application, but is deprecated.
    ###
    @store = @application.__container__.lookup("service:store")
    @session = @application.__container__.lookup("service:session")
    @userParams =
      email: "test@test.test"
      password: "password123"
    Cookies.remove "_dummy_key"
    Cookies.remove "remember-token"
    return

  afterEach: ->
    Ember.run @application, 'destroy'

test 'visiting /', (assert) ->
  visit '/'

  andThen =>
    assert.equal currentURL(), '/'
    @session.login @userParams
  andThen =>
    @oldCookie = Cookies.get "_dummy_key"
    @rememberToken = Cookies.get "remember-token"
    
    assert.ok @oldCookie, "cookie should not be blank"
    assert.ok @rememberToken, "the token should not be blank"
    @owner = @store.createRecord "owner", name: "big ol' homophobe"
    @owner.save()

  andThen =>
    @session.update
      owner: @owner

  andThen =>
    @session
    .get("model")
    .get("owner")
    .then (owner) =>
      assert.ok owner
      assert.equal owner.id, @owner.id, "owner should match"

  andThen =>
    assert.notEqual Cookies.get("_dummy_key"), @oldCookie, "we should have a new cookie"
    @store.findAll "taco"
    .then (tacos) =>
      assert.ok tacos
