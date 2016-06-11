`import DS from 'ember-data'`
`import {Relateable} from 'autox-phoenix'`

Model = DS.Model.extend Relateable,
  
  email: DS.attr "string"
  
  forgetAt: DS.attr "moment"
  
  insertedAt: DS.attr "moment"
  
  password: DS.attr "string"
  
  passwordHash: DS.attr "string"
  
  recoveryHash: DS.attr "string"
  
  rememberToken: DS.attr "string"
  
  updatedAt: DS.attr "moment"
  

  

`export default Model`