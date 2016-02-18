`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
{chain, isObject, tap} = _
{computed, Map, get} = Ember
C1 =
  virtualAttributes: computed ->
    map = Map.create()
    @eachComputedProperty (name, meta) ->
      if meta.isVirtual
        meta.name = name
        map.set name, meta
    map
  actionAttributes: computed ->
    map = Map.create()
    @eachComputedProperty (name, meta) ->
      if meta.isAction
        meta.name = name
        meta.options.actionState.setProperties({name, @modelName})
        map.set name, meta
    map
C2 =
  eachVirtualAttribute: (callback, binding) ->
    get(@, "virtualAttributes").forEach (meta, name) ->
      callback.call binding, name, meta

  eachActionAttribute: (callback, binding) ->
    get(@, "actionAttributes").forEach (meta, name) ->
      callback.call binding, name, meta

Core = chain(C1)
.mapValues (c) -> c.readOnly()
.merge(C2)
.value()

RichModelMixin = Ember.Mixin.create(Core)

`export {RichModelMixin, Core}`
`export default RichModelMixin`
