# Takes two parameters: container and application
initialize = (application) ->
  application.inject "adapter", "session", "service:session"
  application.inject "controller", "session", "service:session"
  application.inject "route", "session", "service:session"
  application.inject "component", "session", "service:session"

SessionInitializer =
  name: 'session'
  initialize: initialize

`export {initialize}`
`export default SessionInitializer`
