# Takes two parameters: container and application
initialize = (application) ->
  application.inject "route", "workflow", "service:workflow"

WorkflowInitializer =
  name: 'workflow'
  initialize: initialize

`export {initialize}`
`export default WorkflowInitializer`
