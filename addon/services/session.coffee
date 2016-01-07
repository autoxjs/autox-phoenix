`import Ember from 'ember'`

{Service, Evented, inject, computed: {alias}} = Ember

SessionService = Service.extend Evented,
  store: inject.service("store")
  id: alias "model.id"
  loggedIn: alias "model.loggedIn"

  instanceInit: ->
    store = @get "store"
    @set "model", store.createRecord "session"
  channelFor: (key) ->
    key = "#{key}-chan"
    return service if (service = @get key)?
    @[key] ?= inject.service(key)
    @get key

  connect: (key) ->
    @get "model"
    .get key
    .then (model) =>
      @channelFor(key)
      .connect model

  disconnect: (key) ->
    @get "model"
    .get key
    .then =>
      @channelFor(key)
      .disconnect()

  updateModel: -> 
    model = @get "model"
    event = if model.get("isNew") then "login" else "change"
    model.save()
    .then (model) =>
      @trigger event, model
      model

  destroyModel: ->
    store = @get "store"
    @get "model"
    .destroyRecord()
    .then => 
      @trigger "logout"
      @set "model", store.createRecord("session")

`export default SessionService`
