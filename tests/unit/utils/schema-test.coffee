`import Ember from 'ember'`
`import moment from 'moment'`
`import SchemaUtils from 'autox/utils/schema'`
`import { moduleForModel, test } from 'ember-qunit'`

moduleForModel 'chair', 'Unit | Utility | schema', {
  # Specify the other units that are required for this test.
  needs: ['model:shop', 
    'model:salsa', 
    'model:taco', 
    'model:relationship',
    'model:history',
    'model:kitchen',
    'model:owner',
    'model:user']
}

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

    fields = SchemaUtils.getFields 
      factory: chairFactory
      ctx: {}
      action: "show"

    assert.ok fields
    assert.equal fields.get("length"), 4, "THERE ARE 4 LIGHTS"

    [insertField, sizeField, updateField, shopField] = fields
    assert.ok insertField, "all four fields should be present"
    assert.equal insertField.get("type"), "moment"
    assert.notOk insertField.get("canModify")
    assert.ok insertField.get("canDisplay")
    assert.ok insertField.get("isBasic")
    assert.equal insertField.get("componentName"), "em-datetime-field"
    assert.ok sizeField, "all four fields should be present"
    assert.ok updateField, "all four fields should be present"
    assert.ok shopField, "all four fields should be present"