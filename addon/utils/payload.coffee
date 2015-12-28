`import Ember from 'ember'`
{Object, A, isBlank} = Ember
Payload = Object.extend
  init: ->
    @_super arguments...
    @attributeKeys = A([])
    @attributeMetas = {}

  eachAttribute: (callback) ->
    @attributeKeys.forEach (key) =>
      callback key, @attributeMetas[key]

  attr: (key)-> @get(key)

  set: (key, value) ->
    @initializeDSAttribute(key, value) if isBlank @attributeMetas[key]
    @_super(key, value)

  initializeDSAttribute: (key, value) ->
    @attributeKeys.pushObject key
    type = t if (t = typeof value) in ["number", "string", "boolean"]
    type ?= switch value.constructor
      when Date then "date"
      when Moment then "moment"
      else null
    @attributeMetas[key] = 
      type: type
      isAttribute: true
      options: {}

`export default Payload`