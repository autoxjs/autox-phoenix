# Takes two parameters: container and application
initialize = (application) ->
  application.inject "controller", "context", "service:context"
  application.inject "route", "context", "service:context"
  application.inject "component", "context", "service:context"

ContextInitializer =
  name: 'context'
  initialize: initialize

`export {initialize}`
`export default ContextInitializer`
