`import Ember from 'ember'`
`import DS from 'ember-data'`
`import Payload from '../utils/payload'`
{isBlank, computed} = Ember
missUseError = (key, child) ->
  "You tried to associate a dirty '#{child.constructor.modelName}' to field '#{key}'," +
  "You should just pass in a regular hash instead"
retardedUserError = (key, x) ->
  "You tried to associate some dumb shit '#{x}' into field '#{key}'"

Relationship = DS.Model.extend
  relatedParentModelName: DS.attr "string", virtual: true
  relatedParentId: DS.attr "string", virtual: true
  relatedChildPath: DS.attr "string", virtual: true
  relatedChildModelName: DS.attr "string", virtual: true
  relatedChildId: DS.attr "string", virtual: true
  
  relatedAttributes: DS.attr defaultValue: -> Payload.create({})

  relatedParent: computed set: (key, parent) ->
    @set "relatedParentModelName", parent.constructor.modelName
    @set "relatedParentId", parent.get("id")
    parent

  relatedChild: computed set: (key, child) ->
    if child?.id? and child?.constructor?.modelName?
      @set "relatedChildId", @assertCorrectType(child).get("id")
    else if child?.constructor?.modelName?
      throw missUseError(key, child)
    else if isBlank child
      throw retardedUserError(key)
    else if typeof child is "object"
      @set(key, value) for key, value of child
    else
      throw retardedUserError(key, child)
    child

  relatedChildMeta: computed set: (key, meta) ->
    {key, kind, type} = meta
    @set "relatedChildPath", key
    @set "relatedChildModelName", type
    meta

  associate: (child) -> 
    @set "relatedChild", child
    @

  assertCorrectType: (child) ->
    expected = child?.constructor?.modelName
    actual = @get("relatedChildModelName")
    return child if expected? and expected is actual
    throw "Expected a child of type #{expected} but got #{actual}"

  get: (key) ->
    if isBlank(@[key]) then @get("relatedAttributes").get(key) else @_super(arguments...)

  set: (key, value) ->
    if isBlank @[key]
      @get("relatedAttributes").set key, value
    else
      @_super arguments...
      
`export default Relationship`
