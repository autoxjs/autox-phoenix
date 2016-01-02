`import Ember from 'ember'`
`import { moduleForModel, test } from 'ember-qunit'`

moduleForModel 'shop', 'Unit | Serializer | relationship',
  # Specify the other units that are required for this test.
  needs: ['serializer:relationship', 'model:relationship', 'model:owner', 'model:salsa', 'model:taco']

# Replace this with your real tests.
test 'it serializes records', (assert) ->
  Ember.run =>
    store = @store()
    shop = @subject(id: 89)
    relation = shop.relate('owner')
    owner = store.createRecord "owner", name: "Fredreich Elmsworth IV", id: 1998
    relation.associate owner
    serializedRecord = relation.serialize()
    assert.deepEqual serializedRecord,
      data:
        id: "1998"
        type: "owners"

    relation.set "secretSource", "applesauce"
    relation.set "accessToken", "xwing-93"
    serializedRecord = relation.serialize()
    assert.deepEqual serializedRecord,
      data:
        id: "1998"
        type: "owners"
        attributes:
          "secret-source": "applesauce"
          "access-token": "xwing-93"
    relation.rollbackAttributes()