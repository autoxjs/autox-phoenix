`import DS from 'ember-data'`
`import {RelateableMixin} from 'autox'`

Model = DS.Model.extend RelateableMixin,
  
  insertedAt: DS.attr "moment"
  
  size: DS.attr "string"
  
  updatedAt: DS.attr "moment"
  

  
  shop: DS.belongsTo "shop", async: true
  

`export default Model`