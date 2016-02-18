`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, fillable, text, isVisible} = PageObject

Page = PageObject.create
  visit: visitable("/shops")
  hasShops: -> @shopCount() > 0
  shopCount: -> $("a.list-group-item[href*=shops]").length
  clickShop: clickable("a.list-group-item[href*=shops]:last-child")

`export default Page`