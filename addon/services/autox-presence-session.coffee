`import Ember from 'ember'`
`import Phoenix from 'ember-phoenix-chan'`
`import getOwner from 'ember-getowner-polyfill'`
{isBlank, Service, Evented, RSVP, computed: {alias}, inject: {service}} = Ember
{Socket} = Phoenix
BadUserError = new Error """
You attempt to establish socket connection failed,
I expected an non-null user, but got a null user.
"""
errMsg = """
You tried to create a channel synchronously,
but the socket hasn't connected yet.

This is likely because you called the `channelSync`
method before the user has successfully logged in his account.
"""
AutoxPresenceSessionService = Ember.Service.extend
  config: service "config"
  session: service "session"
  state: "disconnected"
  namespace: alias "config.autox.socketNamespace"
  userId: alias "session.data.authenticated.user.data.id"
  deferredSocket: RSVP.defer()
  socketPromise: alias "deferredSocket.promise"
  channelFor: (name) ->
    getOwner(@).lookup "service:#{name}-chan"

  onConnect: Ember.on "connect", ->
    @set "state", "connected"
    @get("deferredSocket").resolve(@socket)

  onDisconnect: Ember.on "disconnect", ->
    @set "state", "disconnected"

  onError: Ember.on "error", ->
    if @get("state") is "disconnected"
      @get("deferredSocket").reject(socket)
    else
      @set "state", "error"

  connect: ->
    userId = @get "userId"
    throw BadUserError if isBlank(userId)
    @socket = new Socket @get("namespace"), params: user_id: userId
    @socket.connect()
    @socket.onOpen => @trigger "connect"
    @socket.onClose => @trigger "disconnect"
    @socket.onError => @trigger "error"
    @get "deferredSocket.promise"

`export default AutoxPresenceSessionService`
