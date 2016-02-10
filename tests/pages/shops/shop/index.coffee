`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, fillable, text, isVisible} = PageObject

Page = PageObject.create
  canApproveInspection: isVisible "button[aria-label=approveInspection]"
  approveInspection: clickable("button[aria-label=approveInspection]")

  canOpenForBusiness: isVisible "button[aria-label=openForBusiness]"
  openForBusiness: clickable("button[aria-label=openForBusiness]")

`export default Page`