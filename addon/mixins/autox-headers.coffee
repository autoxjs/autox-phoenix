`import Ember from 'ember'`

volatile = ->
  Ember.computed(arguments...).volatile()
  
AutoxHeaders = Ember.Mixin.create
  session: Ember.inject.service("session")
  headers: volatile "session.rememberToken", ->
    session = @get "session"
    "autox-remember-token": session.get("rememberToken") 

`export default AutoxHeaders`