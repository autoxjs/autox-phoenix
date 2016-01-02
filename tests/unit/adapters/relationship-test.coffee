`import Ember from 'ember'`
`import { moduleForModel, test } from 'ember-qunit'`

moduleForModel 'shop', 'Unit | Adapter | relationship', {
  # Specify the other units that are required for this test.
  needs: ['adapter:relationship', 'serializer:relationship', 'model:owner', 'model:salsa', 'model:taco', 'model:relationship']
}

# Replace this with your real tests.
test 'it should exist and operate as expected', (assert) ->
  shop = @subject(id: 33, name: "Maruyama Farms")
  adapter = @container.lookupFactory("adapter:relationship").create()
  assert.ok adapter, "the adapter should be there"
  Ember.run =>
    store = @store()
    salsa = store.createRecord "salsa",
      id: 11
      name: "Verde"
    relation = shop.relate "salsas"
    relation.associate(salsa)
    relation.set "secretSauce", "hikari no naka"
    snapshot = relation._internalModel.createSnapshot()
    adapter.ajax = (url, verb, {data}) ->
      assert.equal url, "/api/shops/33/relationships/salsas", "url should match"
      assert.equal verb, "DELETE", "verb should match"
      assert.deepEqual data,
        data:
          id: "11"
          type: "salsas"
          attributes:
            "secret-sauce": "hikari no naka"
    adapter.deleteRecord(store, store.modelFor("relationship"), snapshot)

    adapter.ajax = (url, verb, {data}) ->
      assert.equal url, "/api/shops/33/relationships/salsas", "url should match"
      assert.equal verb, "POST", "verb should match"
      assert.deepEqual data,
        data:
          id: "11"
          type: "salsas"
          attributes:
            "secret-sauce": "hikari no naka"
    adapter.createRecord(store, store.modelFor("relationship"), snapshot)

    relation.rollbackAttributes()