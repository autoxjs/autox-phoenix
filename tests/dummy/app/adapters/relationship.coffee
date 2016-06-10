`import Adapter from 'autox-phoenix/adapters/relationship'`
`import ENV from '../config/environment'`

RelationshipAdapter = Adapter.extend
  host: ENV.host
  namespace: ENV.namespace
  cookieKey: ENV.cookieKey
  authorizer: 'authorizer:autox'

`export default RelationshipAdapter`