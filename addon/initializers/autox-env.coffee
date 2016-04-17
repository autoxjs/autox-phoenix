# Takes two parameters: container and application
initialize = (application) ->
  application.inject "controller", "autoxEnv", "service:autox-env"
  application.inject "component", "autoxEnv", "service:autox-env"
AutoxEnvInitializer =
  name: 'autox-env'
  initialize: initialize

`export {initialize}`
`export default AutoxEnvInitializer`
