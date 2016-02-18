`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, fillable, text, isVisible} = PageObject

Page = PageObject.create
  canMateWithShop: isVisible "button[aria-label=mateWithShop]"
  mateWithShop: clickable("button[aria-label=mateWithShop]")

`export default Page`