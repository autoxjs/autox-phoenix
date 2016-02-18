`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, fillable, text, isVisible} = PageObject

Page = PageObject.create
  visit: visitable("/salsas")
  hasSalsas: -> @salsaCount() > 0
  salsaCount: -> $("a.list-group-item[href*=salsas]").length
  clickSalsa: clickable("a.list-group-item[href*=salsas]:last-child")

`export default Page`