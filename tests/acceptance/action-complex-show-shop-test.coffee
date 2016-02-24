`import Ember from 'ember'`
`import { test } from 'qunit'`
`import moduleForAcceptance from '../../tests/helpers/module-for-acceptance'`
`import ShopsNew from '../../tests/pages/shops/new'`
`import ShopsIndex from '../../tests/pages/shops/index'`
`import ShopShow from '../../tests/pages/shops/shop/index'`
`import SalsasIndex from '../../tests/pages/salsas/index'`
`import SalsaShow from '../../tests/pages/salsas/salsa/index'`

moduleForAcceptance 'Acceptance: ActionComplexShowShopTest'

test "salsa -> shop", (assert) ->
  @store = @application.__container__.lookup("service:store")
  fsm = @application.__container__.lookup("service:finite-state-machine").reset()
  currentAction = null
  shopId = null
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
    assert.ok (currentAction = fsm.get "currentAction")
    assert.equal fsm.get("currentAction.activeModelname"), "shop", "we should have an action that requires a shop"
    assert.equal fsm.get("currentAction.modelName"), "salsa", "the action should have the proper model"
    assert.equal fsm.get("currentAction.name"), "mateWithShop", "the action should also have the proper method name"
    assert.equal currentURL(), "/shops", "we should be redirected to the shops index page"
    assert.ok ShopsIndex.hasShops(), "we should have shops on the page"

    ShopsIndex.clickShop()

  andThen ->
    assert.equal currentPath(), "shops.shop.index", "we should be on the shop show page"
    assert.ok ShopShow.canSelectForCurrentAction(), "we should be able to select this the current action"
    shopId = ShopShow.shopId()
    ShopShow.selectForCurrentAction()

  andThen ->
    assert.equal currentAction, fsm.get("currentAction"), "the current action should not have changed"
    assert.equal fsm.get("currentAction.modelName"), "salsa", "the action model should not have changed"
    assert.equal fsm.get("currentAction.name"), "mateWithShop", "the action name should not change"
    assert.equal fsm.get("currentAction.status"), "complete", "status is complete"
    assert.equal currentPath(), "salsas.salsa.index", "we should now be back at the salsa page"

  andThen ->
    ShopsNew.visit().createShop()

  andThen =>
    assert.notEqual shopId, ShopShow.shopId(), "we should be redirected to the correct show page"
    assert.ok shopId < ShopShow.shopId(), "this thing should be made later"
    assert.equal currentPath(), "shops.shop.index"
    wait 10
  andThen =>
    assert.ok ShopShow.canApproveInspection(), "the approve action should be available"
    assert.ok ShopShow.canDenyInspection(), "the deny action should be available"
    assert.notOk ShopShow.canOpenForBusiness(), "this open action should not be available"
    assert.notOk ShopShow.canServeAlcohol(), "the alcohol action should not be available"

    Ember.Test.registerWaiter ShopShow, ShopShow.canServeAlcohol

    ShopShow.approveInspection()

  andThen =>
    assert.ok ShopShow.canOpenForBusiness(), "open business should now become available"
    assert.ok ShopShow.canServeAlcohol(), "serve alcohol should now become available"

    assert.equal ShopShow.beersServed(), 0, "no beers served"
    ShopShow.serveAlcohol()

    Ember.Test.unregisterWaiter ShopShow, ShopShow.canServeAlcohol
    wait 1

  andThen =>
    assert.equal ShopShow.beersServed(), 1, "1 beer served"
    ShopShow.serveAlcohol()
    wait 1

  andThen =>
    assert.equal ShopShow.beersServed(), 2, "2 beer served"
    ShopShow.serveAlcohol()
    wait 1

  andThen =>
    assert.equal ShopShow.beersServed(), 3, "3 beer served"

test "shop -> salsa", (assert) ->
  @container = @application.__container__
  @store = @application.__container__.lookup("service:store")
  fsm = @application.__container__.lookup("service:finite-state-machine").reset()
  currentAction = null
  fsm.set "prev", null
  ShopsNew.visit()

  andThen =>
    collection = @container.lookup("field:shop")
    assert.ok ShopsNew.formPresent(), "the form should be present"
    assert.ok collection.get("sortedFields.length") > 4, "we should have a bunch of fields"
    controller = @container.lookup("controller:shops/new")
    assert.ok controller, "we should have the controller"
    assert.equal controller.get("model.constructor.modelName"), "shop", "it should be the new shop controller"

    fieldStates = controller.get("meta.fields")
    assert.ok controller.get("meta"), "we should have the meta field"
    assert.ok Ember.isArray(fieldStates), "we should have the field states"
  andThen =>
    ShopsNew.createShop()

  andThen =>
    assert.equal currentPath(), "shops.shop.index"
    wait 10
  andThen =>
    assert.ok ShopShow.canApproveInspection(), "the approve action should be available"
    assert.ok ShopShow.canDenyInspection(), "the deny action should be available"
    assert.notOk ShopShow.canOpenForBusiness(), "this open action should not be available"
    assert.notOk ShopShow.canServeAlcohol(), "the alcohol action should not be available"

    ShopShow.approveInspection()


  andThen =>
    assert.ok ShopShow.canOpenForBusiness(), "this action should now become available"
    assert.ok ShopShow.canServeAlcohol(), "this action should now become available"
    assert.equal ShopShow.beersServed(), 0, "no beers served"
    ShopShow.serveAlcohol()
    wait 1

  andThen =>
    assert.equal ShopShow.beersServed(), 1, "1 beer served"
    ShopShow.serveAlcohol()
    wait 1

  andThen =>
    assert.equal ShopShow.beersServed(), 2, "2 beer served"
    ShopShow.serveAlcohol()
    wait 1

  andThen =>
    assert.equal ShopShow.beersServed(), 3, "3 beer served"
    wait 1

  andThen ->
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
    assert.ok (currentAction = fsm.get "currentAction")
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
    assert.equal currentAction, fsm.get("currentAction"), "the current action should not have changed"
    assert.equal fsm.get("currentAction.modelName"), "salsa", "the action model should not have changed"
    assert.equal fsm.get("currentAction.name"), "mateWithShop", "the action name should not change"
    assert.equal fsm.get("currentAction.status"), "complete", "status is complete"
    assert.equal currentPath(), "salsas.salsa.index", "we should now be back at the salsa page"