`import DS from 'ember-data'`
`import {RelateableMixin} from 'autox'`

Model = DS.Model.extend RelateableMixin,
  
  insertedAt: DS.attr "moment"
  
  location: DS.attr "string"
  
  name: DS.attr "string"
  
  updatedAt: DS.attr "moment"
  

  
  chairs: DS.hasMany "chair", async: true
  
  kitchen: DS.belongsTo "kitchen", async: true
  
  owner: DS.belongsTo "owner", async: true
  
  salsas: DS.hasMany "salsa", async: true
  
  tacos: DS.hasMany "taco", async: true
  

`export default Model`