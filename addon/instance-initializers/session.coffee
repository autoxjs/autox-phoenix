# Takes two parameters: container and application
initialize = (instance) ->
  instance.lookup("service:session").instanceInit()

SessionInitializer =
  name: 'session'
  initialize: initialize

`export {initialize}`
`export default SessionInitializer`
