`import Ember from 'ember'`
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
    wait 10
  andThen =>
    assert.ok shopsShopIndex.canApproveInspection(), "the approve action should be available"
    assert.ok shopsShopIndex.canDenyInspection(), "the deny action should be available"
    assert.notOk shopsShopIndex.canOpenForBusiness(), "this open action should not be available"
    assert.notOk shopsShopIndex.canServeAlcohol(), "the alcohol action should not be available"

    shopsShopIndex.approveInspection()

    Ember.Test.registerWaiter shopsShopIndex, shopsShopIndex.canOpenForBusiness

  andThen =>
    assert.ok shopsShopIndex.canOpenForBusiness(), "this action should now become available"
    assert.ok shopsShopIndex.canServeAlcohol(), "this action should now become available"

    Ember.Test.unregisterWaiter shopsShopIndex, shopsShopIndex.canOpenForBusiness
