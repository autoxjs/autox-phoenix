`import { moduleForModel, test } from 'ember-qunit'`

moduleForModel 'shop', 'Unit | Serializer | application',
  # Specify the other units that are required for this test.
  needs: ['serializer:application', 'model:owner', 'model:salsa', 'model:taco', 'model:history']

# Replace this with your real tests.
test 'it extracts hashes properly', (assert) ->
  data =
    id: 987654321
    type: "shops"
    attributes:
      name: "Herald's Pizza"
      location: "Vegas Strip"
    relationships:
      owner:
        links:
          self: "/api/shops/987654321/relationships/owner"
          related: "/api/shops/987654321/owner"
      salsas:
        links:
          self: "/api/shops/987654321/relationships/salsas"
          related: "/api/shops/987654321/salsas"
      tacos:
        links:
          self: "/api/shops/987654321/relationships/tacos"
          related: "/api/shops/987654321/tacos"

  Ember.run =>
    store = @store()
    store.pushPayload("shop", {data})
    shop = store.peekRecord "shop", 987654321
    assert.ok shop, "we should have pushed the shop in"