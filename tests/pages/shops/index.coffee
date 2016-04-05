`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, clickOnText, collection, fillable, text, isVisible} = PageObject

Page = PageObject.create
  visit: visitable("/shops")
  shops: collection
    itemScope: ".autox-collection-for a.list-group-item"
    item:
      id: text(".autox-collection-for__block .autox-show-for__content", at: 0)
      goto: clickable()
  hasShops: -> @shops().count > 0
  shopCount: -> @shops().count
  clickShop: -> @shops(0).goto()
  nextPage: clickable("#next-page")
  prevPage: clickable("#prev-page")
  editLimit: fillable("#page-limit")
  submitLimit: clickable("#page-limit-change")
  changeLimit: (n) -> 
    @editLimit(n)
    @submitLimit()
  firstShop: -> @shops(0)
  firstShopId: -> 
    @firstShop().id
  lastShopContent: -> @shops(@shopCount() - 1).id

`export default Page`