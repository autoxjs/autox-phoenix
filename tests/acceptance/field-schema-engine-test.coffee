`import Ember from 'ember'`
`import { test } from 'qunit'`
`import moduleForAcceptance from '../../tests/helpers/module-for-acceptance'`
`import _ from 'lodash/lodash'`

{chain} = _
moduleForAcceptance 'Acceptance: FieldSchemaEngine'

test 'shop fields', (assert) ->
  @container = @application.__container__
  visit "/"

  andThen =>
    assert.ok(shops = @container.lookup "field:shop")
    assert.notOk shops.create, "collections are instances, not classes"
    assert.equal shops.constructor.modelName, "shop", "we should have the proper model name"

    assert.ok(nameField = @container.lookup "field:shop/name")
    assert.notOk nameField.create, "name field should be an instance, not a class"
    assert.equal nameField.constructor.fieldName, "name", "the field constructor should have proper info"
    assert.equal typeof nameField.initState, "function", "field instances should be able to init state"
    assert.ok Ember.getOwner(shops), "collection should have owner"

    chain(shops.get "fields")
    .tap (fields) ->
      assert.ok fields, "we should get all the fields related to the shop model"
    .map (field) ->
      fn = field?.constructor?.fieldName
      assert.notOk field.create, "a field is an instance, not a class #{fn}"
      assert.ok fn, "fields all should have a field name #{fn}"
      assert.equal typeof field.initState, "function", "all fields should be able to init state #{fn}"
    .value()
    visit "/shops/new"

  andThen =>
    assert.equal currentPath(), "shops.new"

test "salsa fields", (assert) ->
  @container = @application.__container__
  @store = @container.lookup("service:store")
  visit "/"
  @store.pushPayload "salsa",
    data:
      id: "seinaru iyazoi"
      type: "salsas"
      attributes:
        insertedAt: moment()
        updatedAt: moment()
        name: "Verde Ultra"
        price: 2342
        secretSauce: "soy"
  andThen =>
    salsas = @container.lookup "field:salsa"
    assert.ok salsas, "the salsas collection should be present"

    mateActionField = @container.lookup "field:salsa/mate-with-shop"
    assert.ok mateActionField, "we should have found the mate field"
    rawG = mateActionField.get("rawGen")
    assert.equal typeof rawG, "function", "the raw generator is a function"
    g = mateActionField.get("generator")
    assert.ok g, "we should have found the generator"
    assert.equal typeof g, "function", "the generator is a function"
    assert.equal g.constructor.name, "GeneratorFunction", "generator funtions are named so"

    salsa = @store.peekRecord "salsa", "seinaru iyazoi"
    assert.ok salsa
    mateActionField.initState(routeAction: "model#index", model: salsa)
    .then (state) =>
      assert.ok (@sally = state), "we should have an action state"
      assert.equal typeof state.get("iterator").next, "function", "the iterator should be there"
      assert.ok state.get("isVirgin"), "start out as virgins"
      assert.notOk state.get("activeNeed"), "who aren't needy"

  andThen =>
    @sally.invokeAction()

  andThen =>
    assert.notOk @sally.get("isVirgin"), "should no longer be a virgin"
    assert.ok @sally.get("isNeedy"), "should now be needy"
    assert.ok (need = @sally.get("activeNeed")), "sally now has an active need"
    assert.equal need.get("modelName"), "shop", "that need is to shop"
    assert.equal need.get("amount"), 1, "just once is enough"