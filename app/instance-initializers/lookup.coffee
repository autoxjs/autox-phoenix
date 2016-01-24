initialize = (instance) ->
  instance.lookup("service:lookup").instanceInit(instance)

LookupInitializer =
  name: 'lookup'
  initialize: initialize

`export {initialize}`
`export default LookupInitializer`
