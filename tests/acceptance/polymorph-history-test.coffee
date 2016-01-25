`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import startApp from '../../tests/helpers/start-app'`

module 'Acceptance: PolymorphHistory',
  beforeEach: ->
    @application = startApp()
    ###
    Don't return anything, because QUnit looks for a .then
    that is present on Ember.Application, but is deprecated.
    ###
    @store = @application.__container__.lookup("service:store")
    @historyParams =
      type: "single"
      name: "polymorph-history"
    return

  afterEach: ->
    Ember.run @application, 'destroy'

test 'visiting /', (assert) ->
  visit '/'

  andThen =>
    @salsa = @store.createRecord "salsa",
      name: "avocado mild"
      price: 1.34
    @salsa.save()

  andThen =>
    assert.ok @salsa.id, "we should have the salsa"
    @relation = @salsa.relate "histories"
    @relation.associate @historyParams
    attrs = @relation.get "relatedAttributes"
    assert.equal attrs.get("type"), @historyParams.type
    assert.equal attrs.get("name"), @historyParams.name
    @relation.save()

  andThen =>
    @salsa.reload()

  andThen =>
    @salsa
    .get("histories")
    .then (histories) =>
      @history = histories.get "firstObject"
      assert.ok @history
      assert.ok @history.id
  andThen =>
    assert.equal @historyParams.type, @history.get("type")
    assert.equal @historyParams.name, @history.get("name")