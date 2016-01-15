`import Adapter from 'autox/adapters/<%= model %>'`
`import ENV from '../config/environment'`

<%= class %>Adapter = Adapter.extend
  host: ENV.host
  namespace: ENV.namespace
  cookieKey: ENV.cookieKey

`export default <%= class %>Adapter`