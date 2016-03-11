`import Ember from 'ember'`
`import _x from 'autox/utils/xdash'`
`import _ from 'lodash/lodash'`
{RSVP, Service, Evented, isBlank, inject, computed, run, String: {singularize}} = Ember
{alias} = computed
{apply} = _x.computed
{chain, bind} = _
NullModelError = (key) -> """
  You called AutoxSessionContextService.connect with argument '#{key}',
  but is currently null on the session model.
  """

AutoxSessionContextService = Service.extend Evented,
  store: inject.service("store")
  session: inject.service("session")
  authData: alias "session.data.authenticated"
  loggedIn: alias "session.isAuthenticated"

  model: computed "session.isAuthenticated",
    get: ->
      store = @get "store"
      if @get "session.isAuthenticated"
        store.peekRecord "session", @get("authData.data.id")
      else
        store.createRecord "session"
  instanceInit: ->
    session = @get("session")
    session.on "authenticationSucceeded", run.bind(@, @trigger, "login")
    session.on "invalidationSucceeded", run.bind(@, @trigger, "logout")

  channelFor: (key) ->
    key = "#{key}-chan"
    return service if (service = @get key)?
    @[key] ?= inject.service(key)
    @get key

  fetchChannelable: (key) ->
    return @get("model")?.get key
    # id = @get("model.relationships.#{key}.data.id")
    # type = @get("model.relationships.#{key}.data.type")
    # return RSVP.resolve() if isBlank(id) or isBlank(type)
    # @get("store").findRecord singularize(type), id

  connect: (key) ->
    @fetchChannelable(key)
    .then (model) =>
      throw NullModelError(key) if isBlank model 
      @channelFor(key)
      .connect model

  disconnect: (key) ->
    @fetchChannelable(key)
    .then =>
      @channelFor(key)
      .disconnect()

  cast: (params, model) ->
    store = @get "store"
    sessionClass = store.modelFor "session"
    sessionClass.eachAttribute (name) ->
      if (value = Ember.get(params, name))?
        model.set name, value
    sessionClass.eachRelatedType (name) ->
      if (value = Ember.get(params, name))?
        model.set name, value
    model

  login: (params={}) ->
    store = @get "store"
    session = @get("session")
    chain @get("model")
    .thru bind(@cast, @, params)
    .thru bind(session.authenticate, session, "authenticator:autox")
    .value()

  logout: ->
    @get("session").invalidate()

  update: (params={}) ->
    model = @get "model"
    @cast(params, model)
    model
    .save()
    .then (model) =>
      @trigger "change", model
      model
    .catch (error) =>
      console.log error
      throw error

`export default AutoxSessionContextService`
