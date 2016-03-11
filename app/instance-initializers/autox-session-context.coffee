`import ENV from '../config/environment'`

# Takes two parameters: container and application
initialize = (instance) ->
  instance.lookup("service:autox-session-context").instanceInit(ENV.cookieKey)

SessionInitializer =
  name: 'autox-session-context'
  initialize: initialize

`export {initialize}`
`export default SessionInitializer`
