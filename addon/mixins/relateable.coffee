`import Ember from 'ember'`

RelateableMixin = Ember.Mixin.create
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
    @store.createRecord @relationModelName(key),
      relatedParent: @
      relatedChildMeta: Ember.get(@constructor, "relationshipsByName").get(key)

`export default RelateableMixin`
