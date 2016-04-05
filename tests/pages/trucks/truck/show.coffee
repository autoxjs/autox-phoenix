`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, clickOnText, collection, count, fillable, text, contains, isVisible} = PageObject

Page = PageObject.create
  visit: visitable("/:namespace/trucks/truck")
  id: text("[aria-label=id]")
  name: text("[aria-label=name]")
  status: text("[aria-label=status]")
  dockId: text("[aria-label=dock]")
  arriveAtDock: clickable("[aria-label=arriveAtDock]")
  canArriveAtDock: isVisible "[aria-label=arriveAtDock]"
  departFromDock: clickable("[aria-label=departFromDock]")
  canDepartFromDock: isVisible "[aria-label=departFromDock]"
  selectedForAction: clickable "[aria-label=selectedForAction]"
  canSelectedForAction: isVisible "[aria-label=selectedForAction]"
  weirdDockTruck: clickable "[aria-label=weirdDockTruck]"

`export default Page`