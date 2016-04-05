`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, clickOnText, collection, fillable, text, isVisible} = PageObject

Page = PageObject.create
  canMateWithShopV: isVisible "button[aria-label=mateWithShop]"
  canMateWithShop: -> @canMateWithShopV
  mateWithShop: clickable("button[aria-label=mateWithShop]")

`export default Page`