# Takes two parameters: container and application
initialize = (application) ->
  application.inject "adapter", "session", "service:session"

SessionInitializer =
  name: 'session'
  initialize: initialize

`export {initialize}`
`export default SessionInitializer`
