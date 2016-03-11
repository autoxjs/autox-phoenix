`import Ember from 'ember'`
`import _x from '../utils/xdash'`
`import FieldState from '../states/field-state'`

{A, K, inject, RSVP, computed: {map, alias, or: ifAny, not: none}} = Ember
{computed: {apply, match}} = _x
formalize = (x) ->
  switch x
    when "show" then "model#index"
    when "edit" then "model#edit"
    when "new", "index" then "collection##{x}"
    else x
FieldFoundationMixin = Ember.Mixin.create
  lookup: inject.service "lookup"
  fsm: inject.service "finite-state-machine"

  accessName: ifAny "aliasKey", "name"
  aliasKey: alias "meta.options.aliasKey"
  type: alias "meta.type"
  label: ifAny "meta.options.label", "name"
  priority: ifAny "meta.options.priority", "defaultPriority"
  defaultPriority: 1
  description: alias "meta.options.description"
  
  displayers: map "meta.options.display", formalize
  modifiers: map "meta.options.modify", formalize

  isRelationship: alias "meta.isRelationship"
  isAttribute: alias "meta.isAttribute"
  isVirtual: alias "meta.isVirtual"
  isAction: alias "meta.isAction"
  isBasic: none "among"
  among: alias "meta.options.among"
  defaultValue: alias "meta.options.defaultValue"

  presenter: alias "meta.options.presenter"
  isCustomized: apply "presenter", (presenter) -> typeof presenter is "string"
  
  getWhen: -> @get("meta.options")?.when ? true
  initState: (ctx) ->
    FieldState
    .extend
      when: @getWhen()
    .create {ctx, content: @}
    .preload()

`export default FieldFoundationMixin`