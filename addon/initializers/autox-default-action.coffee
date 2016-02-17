# Takes two parameters: container and application
initialize = (application) ->
  application.inject "controller", "autoxDefaultAction", "service:autox-default-action"
  application.inject "component", "autoxDefaultAction", "service:autox-default-action"

AutoxDefaultActionInitializer =
  name: 'autox-default-action'
  initialize: initialize

`export {initialize}`
`export default AutoxDefaultActionInitializer`
