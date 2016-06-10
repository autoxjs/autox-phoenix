`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
{bind, tap} = _
{inject, String, RSVP, Mixin, computed: {equal, alias}, inject: {service}} = Ember
dashingularize = (x) -> String.dasherize String.singularize x
underpluralize = (x) -> String.underscore String.pluralize x

successfulJoin = (chan) ->
  @set "phoenixChan", chan
  @trigger "join"
failedToJoin = (reason) ->
  @set "error", reason
  RSVP.reject @

Events = ["notify", "update", "destroy", "refresh"]

ChanCoreMixin = Mixin.create
  chanParams: {}
  state: alias "channel.state"
  aps: service "autox-presence-session"
  store: service "store"
  socketPromise: alias "aps.socketPromise"
  deferredChannel: RSVP.defer()
  channelPromise: alias "deferredChannel.promise"

  init: ->
    @_super arguments...
    @get("socketPromise").then (socket) =>
      @channel = socket.channel @get("topic"), @get("chanParams")
      @deferredChannel.resolve @channel
      @channel.on event, bind(@trigger, @, event) for event in Events

  connect: ->
    return RSVP.resolve @ if isPresent(@channel)
    @get("channelPromise").then (chan) =>
      chan.join()
      .receive "ok", tap(@, bind(successfulJoin, @, chan))
      .receive "error", tap(@, bind(failedToJoin, @))
      .receive "timeout", tap(@, bind(failedToJoin, @))

  disconnect: ->
    return RSVP.resolve @ if isBlank(@channel)
    @get("channelPromise").then (chan) =>
      chan.leave()
      .receive "ok", => delete @channel

`export default ChanCoreMixin`

# onRefresh: Ember.on "refresh", ({type, id}) ->
#   type = dashingularize(type)
#   if (record = @get("store").peekRecord type, id)? and not record.get("isReloading")
#     Ember.run -> record.reload()
#
# onNotify: Ember.on "notify", ({level, message}) ->
#   level ?= "info"
#   @get("notify")?[level]?message
#
# onUpdate: Ember.on "update", (payload) ->
#   Ember.run => @get("store").pushPayload payload
#
# onDestroy: Ember.on "destroy", (payload) ->
#   {data: {type, id}} = payload
#   type = dashingularize(type)
#   if (record = @get("store").peekRecord type, id)? and not record.get("isSaving")
#     @get("store").unloadRecord record
