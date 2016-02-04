`import Ember from 'ember'`
`import moment from 'moment'`
{isMoment} = moment
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
    type = "moment" if isMoment(value)
    type = "date" if value instanceof Date
    if isBlank type
      console.log value 
      throw """You passed into key '#{key}' a value as shown above,
      this value isn't any of the types I know how to infer, so you gone fucked up
      """
    @attributeMetas[key] = 
      type: type
      isAttribute: true
      options: {}

`export default Payload`