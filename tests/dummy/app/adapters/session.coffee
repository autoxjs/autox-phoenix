`import Adapter from 'autox/adapters/session'`
`import ENV from '../config/environment'`

SessionAdapter = Adapter.extend
  authorizer: 'authorizer:autox'
  host: ENV.host
  namespace: ENV.namespace
  cookieKey: ENV.cookieKey

`export default SessionAdapter`