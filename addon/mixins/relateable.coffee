`import Ember from 'ember'`

RelateableMixin = Ember.Mixin.create
  relate: (key) ->
    @store.createRecord "relationship",
      parent: @
      childMeta: @store.modelFor(@).relationshipsByName().get(key)

`export default RelateableMixin`
