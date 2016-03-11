# Takes two parameters: container and application
initialize = (application) ->
  application.inject "adapter", "xession", "service:autox-session-context"
  application.inject "controller", "xession", "service:autox-session-context"
  application.inject "route", "xession", "service:autox-session-context"
  application.inject "component", "xession", "service:autox-session-context"

SessionInitializer =
  name: 'autox-session-context'
  initialize: initialize

`export {initialize}`
`export default SessionInitializer`
