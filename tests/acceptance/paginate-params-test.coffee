`import Ember from 'ember'`
`import { test } from 'qunit'`
`import moduleForAcceptance from '../../tests/helpers/module-for-acceptance'`
`import ShopsIndex from 'dummy/tests/pages/shops/index'`

moduleForAcceptance 'Acceptance: PaginateParams'

test 'paginate-params', (assert) ->
  paginate = @application.__container__.lookup("service:paginate-params")
  paginate.clear()
  visit '/shops'

  andThen ->
    assert.equal currentURL(), '/shops'
    assert.equal paginate.get("routes.length"), 3, "we should be 3 routes in"
    assert.deepEqual paginate.get("routes").mapBy("routeName"),
      ["application", "shops", "shops.index"]
    assert.equal paginate.get("activeRoute.routeName"), "shops.index", "we should have the right route"
    ShopsIndex.clickShop()

  andThen ->
    assert.equal currentPath(), "shops.shop.index"