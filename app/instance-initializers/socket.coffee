`import Phoenix from 'ember-phoenix-chan'`
`import ENV from '../config/environment'`
`import DS from 'ember-data'`

{Socket} = Phoenix
{socketNamespace} = ENV

initialize = (instance) ->
  instance.lookup("service:socket").instanceInit(Socket, socketNamespace)

SocketInitializer =
  name: 'socket'
  initialize: initialize

`export {initialize}`
`export default SocketInitializer`