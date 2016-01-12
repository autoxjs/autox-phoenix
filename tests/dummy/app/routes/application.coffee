`import Ember from 'ember'`

{Route, inject} = Ember

ApplicationRoute = Route.extend
  session: inject.service("session")
  model: ->
    @get "session"
    .get "self"

`export default ApplicationRoute`

