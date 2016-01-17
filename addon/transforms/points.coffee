`import Ember from 'ember'`
`import DS from 'ember-data'`

pointify = (xy) ->
  [x,y] = xy
  .split ","
  .map parseFloat
  {x,y}

join = (joiner) ->
  ({x,y}) -> "#{x}#{joiner}#{y}"

PointsTransform = DS.Transform.extend
  deserialize: (serialized) ->
    return [] if Ember.isBlank serialized
    serialized
    .split(" ")
    .map pointify

  serialize: (deserialized) ->
    return if Ember.isEmpty deserialized
    deserialized
    .map join(",")
    .join " "

`export default PointsTransform`
