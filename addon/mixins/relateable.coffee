`import Ember from 'ember'`

{isPresent, Mixin, get} = Ember

assertExistence = (key) ->
  return key if isPresent key
  throw new Error """
  You tried to call `relate/1` without any arguments, this is wrong.
  You must call relate with the key of a relationship field in your model!
  """
assertGetMeta = (relationships, key) ->
  return meta if isPresent(meta = relationships.get(key))
  throw new Error """
  Your key: '#{key}' was not found among the known relationships:
  #{JSON.stringify relationships}
  """

RelateableMixin = Mixin.create
  relationModelName: (childName) ->
    parentName = @constructor?.modelName
    defaultName = [parentName, childName, "relationship"].join("-")
    try
      @store.modelFor(defaultName)
      defaultName
    catch error
      if error.message is "No model was found for '#{defaultName}'"
        "relationship"
      else
        throw error

  relate: (key) ->
    meta = assertGetMeta get(@constructor, "relationshipsByName"), key
    @store.createRecord @relationModelName(assertExistence key),
      relatedParent: @
      relatedChildMeta: meta

`export default RelateableMixin`
