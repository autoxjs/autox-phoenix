`import Ember from 'ember'`
{inject: {service}} = Ember
LoginRoute = Ember.Route.extend
  aps: service "autox-presence-session"
  session: service "session"
  userChan: service "user-chan"
  model: -> {}

  actions:
    login: (params) ->
      {userChan, session, aps} = @getProperties "session", "aps", "userChan"
      session.authenticate "authenticator:autox", params
      .then -> aps.connect()
      .then -> userChan.connect()
      .then => @transitionTo "index"


`export default LoginRoute`
