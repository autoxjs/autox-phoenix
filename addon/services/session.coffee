`import Ember from 'ember'`

{RSVP, Service, Evented, isBlank, inject, computed} = Ember
{alias} = computed

NullModelError = (key) -> """
  You called SessionService.connect with argument '#{key}',
  but is currently null on the session model.
  """

SessionService = Service.extend Evented,
  store: inject.service("store")
  id: alias "model.id"
  loggedIn: alias "model.loggedIn"
  initDeference: RSVP.defer()
  self: alias "initDeference.promise"
  cookie: computed "cookieKey",
    get: -> 
      key = @get "cookieKey"
      Cookies.get key
    set: (_, cookie) ->
      key = @get "cookieKey"
      if isBlank cookie
        Cookies.remove key
      else
        Cookies.set key, cookie, expires: 365
      cookie

  instanceInit: (cookieKey) ->
    @set "cookieKey", cookieKey
    store = @get "store"
    store.findAll "session"
    .then (sessions) =>
      session = sessions.objectAt 0
      session ?= store.createRecord "session"
      @set "model", session
    .catch (errors) =>
      @set "model", store.createRecord "session"
    .finally =>
      @trigger("login", @get("model")) if @get("model.id")
      @get("initDeference").resolve(@)
  channelFor: (key) ->
    key = "#{key}-chan"
    return service if (service = @get key)?
    @[key] ?= inject.service(key)
    @get key

  connect: (key) ->
    @get "model"
    .get key
    .then (model) =>
      throw NullModelError(key) if isBlank model 
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
    @cast(model, params)
    model.save()
    .then (model) =>
      @trigger "login", model
      model

  logout: ->
    store = @get "store"
    @get "model"
    .destroyRecord()
    .then => 
      @trigger "logout"
      @set "model", store.createRecord("session")

  update: (params={}) ->
    model = @get "model"
    @cast(model, params)
    model.save()
    .then (model) =>
      @trigger "change", model
      model

  cast: (model, params) ->
    store = @get "store"
    sessionClass = store.modelFor "session"
    sessionClass.eachAttribute (name) ->
      if (value = Ember.get(params, name))?
        model.set name, value
    sessionClass.eachRelatedType (name) ->
      if (value = Ember.get(params, name))?
        model.set name, value

`export default SessionService`
