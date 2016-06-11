`import DS from 'ember-data'`
`import {Relateable} from 'autox-phoenix'`

History = DS.Model.extend Relateable,
  owner: DS.belongsTo "historical", polymorphic: true
  recordableId: DS.attr "string"
  permalink: DS.attr 'string'
  type: DS.attr 'string'
  name: DS.attr 'string',
    display: ["index"]
    label: "Event Name"
  message: DS.attr 'string'
  scheduledAt: DS.attr 'moment'
  happenedAt: DS.attr 'moment'
  mentionedType: DS.attr 'string'
  mentionedId: DS.attr 'string'
  insertedAt: DS.attr 'moment'
  updatedAt: DS.attr 'moment'

`export default History`
