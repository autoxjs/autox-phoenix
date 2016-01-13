`import DS from 'ember-data'`
`import CookieCred from '../mixins/cookie-credentials'`
`import PostUpdate from '../mixins/post-update'`

SessionAdapter = DS.JSONAPIAdapter.extend CookieCred, PostUpdate, {}

`export default SessionAdapter`
