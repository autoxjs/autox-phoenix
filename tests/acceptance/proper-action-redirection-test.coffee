`import Ember from 'ember'`
`import faker from 'faker'`
`import { test } from 'qunit'`
`import moduleForAcceptance from 'dummy/tests/helpers/module-for-acceptance'`
`import TrucksIndex from 'dummy/tests/pages/trucks/index'`
`import TruckShow from 'dummy/tests/pages/trucks/truck/show'`
`import DocksIndex from 'dummy/tests/pages/docks/index'`
`import DockShow from 'dummy/tests/pages/docks/dock/show'`

{RSVP} = Ember
moduleForAcceptance 'Acceptance: ProperActionRedirectionTest'

test "alpha-omega exclusion", (assert) ->
  store = @application.__container__.lookup("service:store")
  fsm = @application.__container__.lookup("service:finite-state-machine").reset()
  visit "/"
  dockId = null
  truckId = null
  andThen ->
    RSVP.hash
      dock: store.createRecord("dock", name: faker.name.firstName()).save()
      truck: store.createRecord("truck", name: faker.name.lastName()).save()

  andThen ->
    assert.notOk fsm.get("currentAction"),
      "there should be no current action"

    TrucksIndex.visit namespace: "omega"

  andThen ->
    assert.equal currentPath(), "omega.trucks.index", 
      "we should be on the right page"
    assert.ok TrucksIndex.hasTrucks(), 
      "the page should have trucks"

    TrucksIndex.clickFirst()

  andThen ->
    assert.equal currentPath(), "omega.trucks.truck.index", 
      "we should get to the trucks show page"
    assert.ok TruckShow.name,
      "the truck should have a valid name"
    assert.ok TruckShow.canArriveAtDock, 
      "the truck should have the arrive action"
    assert.notOk TruckShow.canDepartFromDock, 
      "the truck should not be able to depart from the dock"
    assert.notOk TruckShow.canSelectedForAction,
      "We aren't in a currentAction therefore this should not be visible"

    truckId = TruckShow.id
    TruckShow.arriveAtDock()

  andThen ->
    assert.equal fsm.get("currentAction.debugName"), "truck#arriveAtDock#needy",
      "we should have locked in the right action"
    assert.equal currentPath(), "omega.docks.index", 
      "default action handler should redirect us to the proper docks index"
    assert.ok DocksIndex.hasDocks(), "we should have docks on the docks index page"

    DocksIndex.clickFirst()

  andThen ->
    assert.equal currentPath(), "omega.docks.dock.index",
      "We should be in the proper dock show page"
    assert.ok DockShow.name,
      "The dock should have a valid name"
    assert.ok DockShow.canSelectedForAction,
      "We expect the dock to be eligible for selection in the current action"
    assert.notOk DockShow.canChocolateSprinklesDance,
      "Because we're in the middle of an action, other actions should be disabled"
    assert.notOk DockShow.canBananaCreamDance,
      "Similar, all actions not related to the current one should be disabled"

    dockId = DockShow.id
    DockShow.selectedForAction()

  andThen ->
    assert.equal currentPath(), "omega.trucks.truck.index",
      "We should be redirected back to the truck show page"
    assert.equal TruckShow.id, truckId,
      "We should have redirected to the correct truck page"
    assert.equal TruckShow.dockId, dockId,
      "The effect of the action should have properly aligned dock and truck"
    assert.ok TruckShow.canDepartFromDock,
      "We are at a dock therefore we should be able to leave it"

    TruckShow.weirdDockTruck()

  andThen ->
    assert.equal currentPath(), "alpha.trucks.index",
      "We can properly control fulfillmentPath"