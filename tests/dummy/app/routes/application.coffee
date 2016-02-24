`import Ember from 'ember'`

{Route, inject} = Ember

ApplicationRoute = Route.extend
  session: inject.service("session")
  model: ->
    @get "session"
    .get "self"

  actions:
    transitionTo: ({routeName, model}) ->
      @transitionTo routeName, model
    shopBubble: ->
      console.log "shop bubble in the application"

`export default ApplicationRoute`

