`import DS from 'ember-data'`
`import CookieCred from '../mixins/cookie-credentials'`
`import SessionAdapter from '../mixins/session-adapter'`
`import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin'`

Adapter = DS.JSONAPIAdapter.extend DataAdapterMixin, SessionAdapter,
  authorizer: 'authorizer:autox'

`export default Adapter`
