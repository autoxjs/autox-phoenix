# Takes two parameters: container and application
initialize = (application) ->
  application.inject "route", "fsm", "service:finite-state-machine"
  application.inject "component", "fsm", "service:finite-state-machine"
  application.inject "controller", "fsm", "service:finite-state-machine"

FiniteStateMachineInitializer =
  name: 'finite-state-machine'
  initialize: initialize

`export {initialize}`
`export default FiniteStateMachineInitializer`
