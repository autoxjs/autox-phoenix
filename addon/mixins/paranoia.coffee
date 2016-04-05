`import Ember from 'ember'`
`import DS from 'ember-data'`
`import Importance from 'autox/utils/importance'`

ParanoiaMixin = Ember.Mixin.create
  deletedAt: DS.attr "moment",
    priority: Importance.UtterTrash
    label: "Deleted At"
    description: "The UTC time when this object was marked deleted in the database"
    display: ["show"]

`export default ParanoiaMixin`