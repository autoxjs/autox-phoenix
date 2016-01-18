`import Ember from 'ember'`
`import DS from 'ember-data'`
`import moment from 'moment'`

MomentTransform = DS.Transform.extend
  deserialize: (serialized) ->
    return if Ember.isBlank serialized
    moment serialized

  serialize: (deserialized) ->
    return if Ember.isBlank deserialized
    moment deserialized
    .toISOString()

`export default MomentTransform`