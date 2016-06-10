`import Ember from 'ember'`
{inject: {service}} = Ember
LoginRoute = Ember.Route.extend
  aps: service "autox-presence-session"

  model: ->
    @get("aps")
    .channelFor "user"
    .get("chanParams")

  actions:
    login: (channel) ->
      channel.connect()
      .then => @transitionTo "index"


`export default LoginRoute`
