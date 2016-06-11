`import DS from 'ember-data'`
`import {Relateable} from 'autox-phoenix'`

Model = DS.Model.extend Relateable,
  
  insertedAt: DS.attr "moment"
  
  updatedAt: DS.attr "moment"
  

  
  shop: DS.belongsTo "shop", async: true
  

`export default Model`