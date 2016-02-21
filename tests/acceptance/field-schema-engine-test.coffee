`import Ember from 'ember'`
`import { test } from 'qunit'`
`import moduleForAcceptance from '../../tests/helpers/module-for-acceptance'`
`import _ from 'lodash/lodash'`

{chain} = _
moduleForAcceptance 'Acceptance: FieldSchemaEngine'

test 'visiting /', (assert) ->
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