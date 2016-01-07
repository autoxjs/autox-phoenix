`import Ember from 'ember'`
`import DS from 'ember-data'`

ApplicationSerializer = DS.JSONAPISerializer.extend
  keyForAttribute: (key, method) ->
    Ember.String.underscore(key)
  keyForRelationship: (key, typeClass, method) ->
    Ember.String.underscore(key)

`export default ApplicationSerializer`
