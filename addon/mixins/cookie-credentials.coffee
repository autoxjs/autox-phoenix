`import Ember from 'ember'`
  
CookieCredentials = Ember.Mixin.create
  ajaxOptions: ->
    hash = @_super arguments...
    hash.xhrFields = 
      withCredentials: true
    hash

`export default CookieCredentials`