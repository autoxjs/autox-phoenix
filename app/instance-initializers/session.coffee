`import ENV from '../config/environment'`

# Takes two parameters: container and application
initialize = (instance) ->
  instance.lookup("service:session").instanceInit(ENV.cookieKey)

SessionInitializer =
  name: 'session'
  initialize: initialize

`export {initialize}`
`export default SessionInitializer`
