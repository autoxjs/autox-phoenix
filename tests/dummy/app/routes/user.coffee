`import Ember from 'ember'`

{Route, inject} = Ember

UserRoute = Route.extend
  session: inject.service("session")
  model: ->
    @get "session"
    .get "model"
    .get "user"

`export default UserRoute`

