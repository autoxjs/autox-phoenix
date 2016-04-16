`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, clickOnText, collection, fillable, text, isVisible} = PageObject

Page = PageObject.create
  id: text("[aria-label=id]")
  material: text("[aria-label=material]")
  weight: text("[aria-label=weight]")
  importAppointment: text("[aria-label=importAppointment]")
  exportAppointment: text("[aria-label=exportAppointment]")

`export default Page`