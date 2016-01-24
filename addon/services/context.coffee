`import Ember from 'ember'`
{inject, Object, Service, Evented, A, isBlank} = Ember

## The Context service provides a way to store sessional data
## Access this through the session service

ContextService = Service.extend Evented,
  session: inject.service("session")
  instanceInit: ->
    session = @get "session"
    session.on "logout", => @reset()
    @reset()
  reset: ->
    @storage = Object.create()
    @keys = A()
    @trigger "reset"

  update: (key, x) ->
    if isBlank x
      @keys.removeObject key
    else
      @keys.pushObject key

    if typeof x is "function"
      x = x(@storage.get key)

    @storage.set key, x
    @

  fetch: (key) ->
    @storage.get key

`export default ContextService`
