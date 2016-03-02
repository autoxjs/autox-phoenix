`import { moduleFor, test } from 'ember-qunit'`

moduleFor 'service:paginate-params', 'Unit | Service | paginate params', {
  # Specify the other units that are required for this test.
  # needs: ['service:foo']
}

class FauxRoute
  constructor: (@routeName) ->

# Replace this with your real tests.
test "it handles proper pushing and pop of routes", (assert) ->
  app = new FauxRoute "application"
  shops = new FauxRoute "shops"
  shop = new FauxRoute "shops.shop"
  products = new FauxRoute "shops.shop.products"

  service = @subject().clear()
  assert.notOk service.get("activeRoute"), "we should not have an routes yet"
