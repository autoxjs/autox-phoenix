`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, fillable, text, isVisible} = PageObject

Page = PageObject.create
  visit: visitable("/shops")
  hasShops: -> @shopCount() > 0
  shopCount: -> $("a.list-group-item[href*=shops]").length
  clickShop: clickable("a.list-group-item[href*=shops]:last-child")
  nextPage: clickable("#next-page")
  prevPage: clickable("#prev-page")
  editLimit: fillable("#page-limit")
  submitLimit: clickable("#page-limit-change")
  changeLimit: (n) -> 
    @editLimit(n)
    @submitLimit()
  firstShop: ->
    $("a.list-group-item[href*=shops]:first-child")
  firstShopId: ->
    @firstShop()
    .find(".autox-collection-for__block:first-child > .autox-show-for__content")
    .text()
    .trim()
  lastShopContent: ->
    $("a.list-group-item[href*=shops]:last-child").text()

`export default Page`