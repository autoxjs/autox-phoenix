`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, clickOnText, collection, fillable, text, isVisible} = PageObject

Page = PageObject.create
  visit: visitable("/:namespace/trucks")
  trucks: collection
    itemScope: ".autox-collection-for a.list-group-item"
    item:
      id: text(".autox-collection-for__block", at: 0)
      goto: clickable()

  hasTrucks: -> @trucks().count > 0
  clickFirst: -> @trucks(0).goto()

`export default Page`