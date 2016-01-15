`import DS from 'ember-data'`
`import CookieCred from '../mixins/cookie-credentials'`
`import SessionAdapter from '../mixins/session-adapter'`

Adapter = DS.JSONAPIAdapter.extend CookieCred, SessionAdapter, {}

`export default Adapter`
