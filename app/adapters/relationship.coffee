`import Adapter from 'ember-autox/adapters/relationship'`
`import ENV from '../config/environment'`

RelAdapter = Adapter.extend
  host: ENV.host
  namespace: ENV.namespace

`export default RelAdapter`