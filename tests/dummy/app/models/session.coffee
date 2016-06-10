`import DS from 'ember-data'`
`import Ember from 'ember'`
`import {SessionState} from 'autox-phoenix'`

Session = DS.Model.extend Ember.Evented, SessionState,

  email: DS.attr "string"

  password: DS.attr "string"

  rememberMe: DS.attr "boolean"

  rememberToken: DS.attr "string"



  owner: DS.belongsTo "owner", async: true

  user: DS.belongsTo "user", async: true


`export default Session`
