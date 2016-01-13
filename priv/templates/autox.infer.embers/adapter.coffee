`import Adapter from 'autox/adapters/<%= model %>'`
`import ENV from '../config/environment'`

<%= class %>Adapter = Adapter.extend
  host: ENV.host
  namespace: ENV.namespace

`export default <%= class %>Adapter`