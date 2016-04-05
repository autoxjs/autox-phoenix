`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, clickOnText, collection, fillable, text, isVisible} = PageObject

Page = PageObject.create
  visit: visitable("/:namespace/docks/dock/:id")
  id: text("[aria-label=id]")
  name: text("[aria-label=name]")
  status: text("[aria-label=status]")

  canSelectedForAction: isVisible "[aria-label=selectedForAction]"
  selectedForAction: clickable "[aria-label=selectedForAction]"
  chocolateSprinklesDance: clickable "[aria-label=chocolateSprinklesDance]"
  canChocolateSprinklesDance: isVisible "[aria-label=chocolateSprinklesDance]"
  bananaCreamDance: clickable "[aria-label=bananaCreamDance]"
  canBananaCreamDance: isVisible "[aria-label=bananaCreamDance]"
      

`export default Page`