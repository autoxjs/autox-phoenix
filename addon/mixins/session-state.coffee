`import Ember from 'ember'`
{Mixin, String} = Ember

cookieKill = (key) -> Cookies.remove String.dasherize key

SessionStateMixin = Mixin.create
  cookieGet: (key) -> 
    if (value = Cookies.get key)?
      @set key, value
    value
  cookieSet: (key) ->
    if (value = @get key)? 
      Cookies.set(String.dasherize(key), value, expires: 365) 
    else
      cookieKill key

  didCreate: ->
    @_super arguments...
    @cookieSet "rememberToken"
    @set "loggedIn", true
  didDelete: ->
    @_super arguments...
    cookieKill "rememberToken"
    @set "loggedIn", false
  ready: ->
    @_super arguments...
    @cookieGet "rememberToken"
    @set "loggedIn", false

`export default SessionStateMixin`
