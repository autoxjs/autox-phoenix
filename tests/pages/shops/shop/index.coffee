`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, clickOnText, collection, fillable, text, isVisible} = PageObject

Page = PageObject.create
  canApproveInspectionV: isVisible "button[aria-label=approveInspection]"
  canApproveInspection: -> @canApproveInspectionV
  approveInspection: clickable("button[aria-label=approveInspection]")

  canDenyInspectionV: isVisible "button[aria-label=denyInspection]"
  canDenyInspection: -> @canDenyInspectionV
  denyInspection: clickable("button[aria-label=denyInspection]")

  canServeAlcoholV: isVisible "button[aria-label=serveAlcohol]"
  canServeAlcohol: -> @canServeAlcoholV
  serveAlcohol: clickable "button[aria-label=serveAlcohol]"

  canOpenForBusinessV: isVisible "button[aria-label=openForBusiness]"
  canOpenForBusiness: -> @canOpenForBusinessV
  openForBusiness: clickable("button[aria-label=openForBusiness]")

  canSelectForCurrentActionV: isVisible "button[aria-label=selectedForAction]"
  canSelectForCurrentAction: -> @canSelectForCurrentActionV
  selectForCurrentAction: clickable "button[aria-label=selectedForAction]"

  shopOwnerV: text ".autox-show-for__content[aria-label=owner]"
  shopOwner: -> @shopOwnerV
  shopIdV: text ".autox-show-for__content[aria-label=id]"
  shopId: -> @shopIdV
  historyStatusV: text ".autox-show-for__content[aria-label=historyStatus]"
  historyStatus: -> @historyStatusV
  beersServedStr: text ".autox-show-for__content[aria-label=beersServed]"
  beersServed: -> parseInt @beersServedStr

`export default Page`