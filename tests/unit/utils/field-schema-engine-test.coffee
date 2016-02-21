`import Ember from 'ember'`
`import moment from 'moment'`
`import {getFieldCollection} from 'autox/utils/field-schema-engine'`
`import { moduleForModel, test } from 'ember-qunit'`

moduleForModel 'chair', 'Unit | Utility | field schema engine',
  needs: [
    'model:shop'
    'model:salsa'
    'model:taco'
    'model:relationship'
    'model:history'
    'model:kitchen'
    'model:owner'
    'model:user'
  ]

test "it should spit out the fields", (assert) ->
  chairParams = 
    id: 6546
    insertedAt: moment()
    updatedAt: moment()
    size: "small"
  Ember.run =>
    store = @store()
    chair = @subject chairParams
    chairFactory = store.modelFor "chair"

    assert.ok store, "the store should be there"
    assert.ok chair, "the chair should be made"
    assert.equal chair.id, 6546, "the chair should have the right id"
    assert.equal chairFactory.modelName, "chair", "we should have the right factory"

    collectionClass = getFieldCollection chairFactory

    assert.ok collectionClass.create, "collections can be created"
    collection = collectionClass.create()
    assert.ok collection, "collections are created"

    fieldClasses = collectionClass.fieldClasses
    assert.ok fieldClasses, "we should have fieldClasses"
    assert.equal fieldClasses.get("length"), 8, "we have 8 fields"
    for fieldClass in fieldClasses
      assert.ok fieldClass.fieldName, "we should have field names"
      assert.ok fieldClass.create, "field classes should be createable"

    fields = fieldClasses.invoke "create"
    assert.ok fields
    assert.ok fields.sortBy, "fields should be sortable"
    sortedFields = fields.sortBy "priority"
    assert.equal sortedFields.get("length"), 8, "THERE ARE 4 LIGHTS"

    [idField, nameField, refField, costField, sizeField, shopField, insertField, updateField] = sortedFields.toArray()
    assert.ok insertField, "all four fields should be present"
    assert.equal insertField.get("type"), "moment", "type of insert should be moment"
    assert.ok insertField.get("isBasic"), "insert should be basic"
    assert.equal insertField.get("componentName"), "em-datetime-field"
    assert.ok sizeField, "all four fields should be present"
    assert.ok updateField, "all four fields should be present"
    assert.ok shopField, "all four fields should be present"

    assert.deepEqual nameField.get("displayers"),
      ["model#index", "collection#index"],
      "the expected dispaly criteria should be present"

    nameField.initState
      model: chair
      routeAction: "model#index"
    .then (fieldState) ->
      assert.equal fieldState.get("routeAction"), "model#index"
      assert.ok fieldState.get("canDisplay"), "the name field should be displayable"
      assert.notOk fieldState.get("canModify"), "the name field should not be modifyable"

    insertField.initState
      model: chair
      routeAction: "model#index"
    .then (fieldState) ->
      assert.notOk fieldState.get("canModify"), "insert can't be modified"
      assert.ok fieldState.get("canDisplay"), "insert can be displayed"