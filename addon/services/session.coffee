`import Ember from 'ember'`

{Service, Evented, inject, computed: {alias}} = Ember

SessionService = Service.extend Evented,
  store: inject.service("store")
  id: alias "model.id"
  loggedIn: alias "model.loggedIn"

  instanceInit: ->
    store = @get "store"
    store.findAll "session"
    .then ([session]) =>
      session ?= store.createRecord "session"
      @set "model", session
    .catch (errors) =>
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

  login: (params={}) ->
    model = @get "model"
    {email, password} = params
    if email? and password?
      model.set "email", email
      model.set "password", password
    {rememberToken} = params
    if rememberToken?
      model.set "rememberToken", rememberToken
    @updateModel()

  logout: ->
    @destroyModel()

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
