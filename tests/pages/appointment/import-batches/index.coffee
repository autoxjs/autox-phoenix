`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, clickOnText, collection, fillable, text, isVisible} = PageObject

Page = PageObject.create
  visit: visitable("/appointment/:id/import-batches")
  batches: collection
    itemScope: ".autox-collection-for a.list-group-item"
    item:
      id: text(".autox-collection-for__block", at: 0)
      goto: clickable()

  hasBatches: -> @batches().count > 0
  clickFirst: -> @batches(0).goto()

`export default Page`