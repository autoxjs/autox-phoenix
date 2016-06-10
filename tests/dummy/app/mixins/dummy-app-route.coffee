`import Ember from 'ember'`
{inject: {service}} = Ember;

DummyAppRoute = Ember.Mixin.create
  session: service("session")
  presence: service "autox-presence-session"
  model: ->
    # if @get("session.isAuthenicated")
    #   @get "presence"
    #   .connect()
  sessionAuthenticated: ->
    @refresh()
  sessionInvalidated: ->
    @refresh()
  actions:
    attemptLogout: ->
      @get("session").invalidate()

    transitionTo: ({routeName, model}) ->
      @transitionTo routeName, model
    shopBubble: ->
      console.log "shop bubble in the application"

`export default DummyAppRoute`
