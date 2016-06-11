`import DS from 'ember-data'`
`import {Relateable} from 'autox-phoenix'`

Model = DS.Model.extend Relateable,
  
  calories: DS.attr "number"
  
  insertedAt: DS.attr "moment"
  
  name: DS.attr "string"
  
  updatedAt: DS.attr "moment"
  

  
  shops: DS.hasMany "shop", async: true
  

`export default Model`