`import Ember from 'ember'`

{Route, inject} = Ember

IndexRoute = Route.extend
  session: inject.service("session")
  model: ->
    @get "session"
    .get "model"

  actions:
    attemptLogin: ->
      @get("session")
      .login 
        email: "test@test.test"
        password: "password123"
      .then =>
        @transitionTo "user"
`export default IndexRoute`

