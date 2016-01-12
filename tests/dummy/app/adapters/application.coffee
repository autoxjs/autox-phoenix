`import Adapter from 'autox/adapters/application'`
`import ENV from '../config/environment'`

AppAdapter = Adapter.extend
  host: ENV.host
  namespace: ENV.namespace

  handleResponse: (status, headers, payload) ->
    console.log status
    console.log headers
    console.log payload
    @_super arguments...

`export default AppAdapter`
