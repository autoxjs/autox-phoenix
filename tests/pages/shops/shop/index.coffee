`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, fillable, text, isVisible} = PageObject

Page = PageObject.create
  canApproveInspection: isVisible "button[aria-label=approveInspection]"
  approveInspection: clickable("button[aria-label=approveInspection]")

  canDenyInspection: isVisible "button[aria-label=denyInspection]"
  denyInspection: clickable("button[aria-label=denyInspection]")

  canServeAlcohol: isVisible "button[aria-label=serveAlcohol]"
  serveAlcohol: clickable "button[aria-label=serveAlcohol]"

  canOpenForBusiness: isVisible "button[aria-label=openForBusiness]"
  openForBusiness: clickable("button[aria-label=openForBusiness]")

  canSelectForCurrentAction: isVisible "button[aria-label=selectedForAction]"
  selectForCurrentAction: clickable "button[aria-label=selectedForAction]"

`export default Page`