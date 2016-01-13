`import DS from 'ember-data'`
`import CookieCred from '../mixins/cookie-credentials'`

ApplicationAdapter = DS.JSONAPIAdapter.extend CookieCred, {}

`export default ApplicationAdapter`
