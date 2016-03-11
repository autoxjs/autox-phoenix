`import Ember from 'ember'`
`import PageObject from 'dummy/tests/page-object'`

{$, isPresent} = Ember
{visitable, clickable, fillable, text, isVisible} = PageObject

Page = PageObject.create
  visit: visitable("/")
  clickLogin: clickable("button#login")
  clickLogout: clickable("button#logout")
  canLogin: -> $("button#login").length
  canLogout: -> $("button#logout").length
  login: ->
    @visit().clickLogin()

`export default Page`