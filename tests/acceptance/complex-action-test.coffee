`import Ember from 'ember'`
`import { test } from 'qunit'`
`import moduleForAcceptance from '../../tests/helpers/module-for-acceptance'`
`import ShopsIndex from '../../tests/pages/shops/index'`
`import ShopShow from '../../tests/pages/shops/shop/index'`
`import SalsasIndex from '../../tests/pages/salsas/index'`
`import SalsaShow from '../../tests/pages/salsas/salsa/index'`
moduleForAcceptance 'Acceptance: ComplexAction'

test 'Multiaction shop and salsa', (assert) ->
  fsm = @application.__container__.lookup("service:finite-state-machine")
  SalsasIndex.visit()
  andThen ->
    assert.notOk fsm.get("currentAction"), "no action should be selected"
    assert.equal currentURL(), '/salsas'
    assert.ok SalsasIndex.hasSalsas(), "we should have salsas on the page"

    SalsasIndex.clickSalsa()

  andThen ->
    assert.equal currentPath(), "salsas.salsa.index", "we should be on a salsa show page"
    assert.ok SalsaShow.canMateWithShop(), "we should have the multi-action"
    SalsaShow.mateWithShop()

  andThen ->
    assert.equal fsm.get("currentAction.activeModelname"), "shop", "we should have an action that requires a shop"
    assert.equal fsm.get("currentAction.modelName"), "salsa", "the action should have the proper model"
    assert.equal fsm.get("currentAction.name"), "mateWithShop", "the action should also have the proper method name"
    assert.equal currentURL(), "/shops", "we should be redirected to the shops index page"
    assert.ok ShopsIndex.hasShops(), "we should have shops on the page"

    ShopsIndex.clickShop()

  andThen ->
    assert.equal currentPath(), "shops.shop.index", "we should be on the shop show page"
    assert.ok ShopShow.canSelectForCurrentAction(), "we should be able to select this the current action"
    ShopShow.selectForCurrentAction()

  andThen ->
    assert.equal currentPath(), "salsas.salsa.index", "we should now be back at the salsa page"
    assert.ok fsm.get("currentAction.allFulfilled"), "the current action should be ready for fulfillment"
    assert.ok SalsaShow.canMateWithShop()
    SalsaShow.mateWithShop()

  andThen ->
    assert.ok fsm.get("currentAction.isComplete"), "the action should be complete"