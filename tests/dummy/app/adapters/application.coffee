`import Adapter from 'autox-phoenix/adapters/application'`
`import ENV from '../config/environment'`

ApplicationAdapter = Adapter.extend
  authorizer: 'authorizer:autox'
  host: ENV.host
  namespace: ENV.namespace
  cookieKey: ENV.cookieKey

`export default ApplicationAdapter`