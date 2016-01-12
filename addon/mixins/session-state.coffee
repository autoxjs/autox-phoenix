`import Ember from 'ember'`
{Mixin, String, computed: {or: ifPresent}} = Ember

cookieKill = (key) -> Cookies.remove String.dasherize key

SessionStateMixin = Mixin.create
  loggedIn: ifPresent "id"
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
  didDelete: ->
    @_super arguments...
    cookieKill "rememberToken"
  ready: ->
    @_super arguments...
    @cookieGet "rememberToken"

`export default SessionStateMixin`
