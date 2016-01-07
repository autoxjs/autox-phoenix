`import DS from 'ember-data'`
`import {RelateableMixin} from 'autox'`

Model = DS.Model.extend RelateableMixin,
  
  insertedAt: DS.attr "moment"
  
  name: DS.attr "string"
  
  price: DS.attr "number"
  
  secretSauce: DS.attr "string"
  
  updatedAt: DS.attr "moment"
  
  whatever: DS.attr "string"
  

  
  shops: DS.hasMany "shop", async: true
  

`export default Model`