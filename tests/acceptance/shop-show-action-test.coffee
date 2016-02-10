`import { test } from 'qunit'`
`import moduleForAcceptance from '../../tests/helpers/module-for-acceptance'`
`import shopsNew from '../../tests/pages/shops/new'`
`import shopsShopIndex from '../../tests/pages/shops/shop/index'`
moduleForAcceptance 'Acceptance: ShopShowAction'

test 'checking correct auto rendering', (assert) ->
  @store = @application.__container__.lookup("service:store")
  shopsNew.visit().createShop()

  andThen =>
    assert.equal currentPath(), "shops.shop.index"
    assert.ok shopsShopIndex.canApproveInspection(), "the action should be available"
    assert.notOk shopsShopIndex.canOpenForBusiness(), "this action should not be available"

    shopsShopIndex.approveInspection()

  andThen =>
    assert.ok shopsShopIndex.canOpenForBusiness(), "this action should now become available"
