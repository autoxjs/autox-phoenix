`import Ember from 'ember'`
`import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin'`
{Route, inject} = Ember

ApplicationRoute = Route.extend ApplicationRouteMixin,
  session: inject.service("session")
  socket: inject.service("socket")
  model: ->
    if @get("session.isAuthenicated")
      @get "socket"
      .connect()
  sessionAuthenticated: ->
    @refresh()
  sessionInvalidated: ->
    @refresh()
  actions:
    attemptLogout: ->
      @get("session").invalidate()
    attemptLogin: ->
      @xession.login 
        email: "test@test.test"
        password: "password123"

    transitionTo: ({routeName, model}) ->
      @transitionTo routeName, model
    shopBubble: ->
      console.log "shop bubble in the application"

`export default ApplicationRoute`

