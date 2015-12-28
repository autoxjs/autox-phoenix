`import Ember from 'ember'`
`import { moduleForModel, test } from 'ember-qunit'`

moduleForModel 'shop', 'Unit | Model | relationship', {
  # Specify the other units that are required for this test.
  needs: ["model:relationship", "model:owner", "model:salsa", "model:taco"]
}

test 'it exists', (assert) ->
  shop = @subject()
  assert.equal typeof shop?.relate, 'function', "basic models exist and can relate to other things"
  assert.equal shop.constructor.modelName, "shop", "the model name should be correct"

  store = @store()
  assert.equal typeof store?.modelFor, 'function', "the store works as expected"

  factory = store.modelFor("shop")
  assert.ok factory.modelName, "shop", "stores should properly provide model factories"

test 'it can relate', (assert) ->
  Ember.run =>
    store = @store()
    shop = @subject(id: 4)
    relation = shop.relate("owner")
    assert.ok relation
    assert.equal relation.get("relatedParent"), shop
    assert.equal relation.get("relatedParentModelName"), "shop", "it should have the proper parent name"
    assert.equal relation.get("relatedParentId"), 4, "it should properly have id"
    assert.equal relation.get("relatedChildPath"), "owner", "the child path should be correct"
    assert.equal relation.get("relatedChildModelName"), "owner", "it should match"

    owner = store.createRecord "owner", name: "Charleston Hesser", id: 777
    relation.associate owner
    assert.equal relation.get("relatedChildId"), 777, "associating a relation should work"
    relation.rollbackAttributes()