`import DS from 'ember-data'`
`import {RelateableMixin} from 'ember-autox'`

Model = DS.Model.extend RelateableMixin,
  
  insertedAt: DS.attr "moment"
  
  name: DS.attr "string"
  
  price: DS.attr "number"
  
  updatedAt: DS.attr "moment"
  

  
  shops: DS.hasMany "shop", async: true
  

`export default Model`