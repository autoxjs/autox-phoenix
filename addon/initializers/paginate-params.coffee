# Takes two parameters: container and application
initialize = (application) ->
  application.__container__.lookup "service:paginate-params"
  .clear()
  application.inject "controller", "paginate", "service:paginate-params"

PaginateParamsInitializer =
  name: 'paginate-params'
  initialize: initialize

`export {initialize}`
`export default PaginateParamsInitializer`
