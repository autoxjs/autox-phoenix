`import Ember from 'ember'`
{inject, String, RSVP, Mixin, computed: {equal}} = Ember
dashingularize = (x) -> String.dasherize String.singularize x
underpluralize = (x) -> String.underscore String.pluralize x

ChanCoreMixin = Mixin.create
  state: "disconnected"
  isConnected: equal "state", "connected"
  isConnecting: equal "state", "connecting"
  isDisconnecting: equal "state", "disconnecting"
  isDisconnected: equal "state", "disconnected"
  socket: inject.service "socket"
  store: inject.service "store"
  notify: inject.service "notify"
  makeTopic: (model) ->
    id = model.get "id"
    type = underpluralize model.constructor.modelName
    "#{type}:#{id}"

  connect: (subject) ->
    return @p if @get("isConnecting") or @get("isConnected")
    @set "topic", (topic = @makeTopic(subject))
    @get("socket").channel(topic)
    .then (chan) =>
      chan.on "notify", (payload) => @trigger "notify", payload
      chan.on "update", (payload) => @trigger "update", payload
      chan.on "destroy", (payload) => @trigger "destroy", payload
      @joinChan chan

  onNotify: Ember.on "notify", ({level, message}) ->
    level ?= "info"
    @get("notify")?[level]?message

  onUpdate: Ember.on "update", (payload) ->
    Ember.run => @get("store").pushPayload payload

  onDestroy: Ember.on "destroy", (payload) ->
    {data: {type, id}} = payload
    type = dashingularize(type)
    if (record = @get("store").peekRecord type, id)? and not record.get("isSaving")
      @get("store").unloadRecord record

  onJoin: Ember.on "join", ->
    @set "state", "connected"
    return if @get("alreadySetupLeave")
    @get("socket").on "disconnect", => @disconnect()
    @set "alreadySetupLeave", true

  joinChan: (chan) ->
    @set "chan", chan
    @p = new RSVP.Promise (resolve, reject) =>
      @set "state", "connecting"
      chan.join()
      .receive "ok", => 
        @trigger "join" 
        resolve(@)
      .receive "error", (reason) => 
        @set "state", "disconnected"
        reject(reason)
      .receive "timeout", => 
        @set "state", "disconnected"
        reject(@)

  disconnect: ->
    return @p if @get("isDisconnecting") or @get("isDisconnected")
    @p = new RSVP.Promise (resolve, reject) =>
      @set "state", "disconnecting"
      @get "chan"
      .leave()
      .receive "ok", =>
        @set "state", "disconnected"
        resolve @
      .receive "error", =>
        @set "state", "connected"
        reject @
      .receive "timeout", =>
        @set "state", "disconnected"
        resolve @

`export default ChanCoreMixin`
