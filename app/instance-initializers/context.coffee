initialize = (instance) ->
  instance.lookup("service:context").instanceInit()

ContextInitializer =
  name: 'context'
  initialize: initialize

`export {initialize}`
`export default ContextInitializer`
