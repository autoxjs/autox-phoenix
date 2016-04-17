`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, clickOnText, collection, fillable, text, isVisible} = PageObject

Page = PageObject.create
  id: text("[aria-label=id]")
  name: text("[aria-label=name]")
  material: text("[aria-label=material]")
  importBatches: text("[aria-label=importBatches]")
  exportBatches: text("[aria-label=exportBatches]")
  clickImportBatches: clickable("a[href*=import-batches]")

`export default Page`