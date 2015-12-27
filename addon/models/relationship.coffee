`import Ember from 'ember'`
`import DS from 'ember-data'`

{isBlank, computed} = Ember

Relationship = DS.Model.extend
  relatedParentModelName: DS.attr "string", virtual: true
  relatedParentId: DS.attr "string", virtual: true
  relatedChildPath: DS.attr "string", virtual: true
  relatedChildModelName: DS.attr "string", virtual: true
  relatedChildId: DS.attr "string", virtual: true

  relatedParent: computed set: (key, parent) ->
    @set "relatedParentModelName", parent.constructor.modelName
    @set "relatedParentId", parent.get("id")
    parent

  relatedChild: computed set: (key, child) ->
    @set "relatedChildId", @assertCorrectType(child).get("id")
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
    throw new Error "Expected a child of type #{expected} but got #{actual}"
      
`export default Relationship`
