`import Ember from 'ember'`
`import _x from '../utils/xdash'`

{A, K, computed: {map, alias, or: ifAny}} = Ember
{computed: {apply, match}} = _x
formalize = (x) ->
  switch x
    when "show" then "model#index"
    when "edit" then "model#edit"
    when "new", "index" then "collection##{x}"
    else x
FieldCoreMixin = Ember.Mixin.create
  lookup: alias "ctx.lookup"
  action: alias "ctx.action"
  
  accessName: ifAny "aliasKey", "name"
  aliasKey: alias "meta.options.aliasKey"
  type: alias "meta.type"
  label: ifAny "meta.options.label", "name"
  priority: ifAny "meta.options.priority", "defaultPriority"
  defaultPriority: 1
  description: alias "meta.options.description"
  
  displayers: map "meta.options.display", formalize
  modifiers: map "meta.options.modify", formalize
  canOnlyDisplay: apply "displayers", "action", (xs, x) -> A(xs).contains x
  canModify: apply "modifiers", "action", (xs, x) -> A(xs).contains x
  isRelationship: alias "meta.isRelationship"
  isAttribute: alias "meta.isAttribute"
  isVirtual: alias "meta.isVirtual"
  isAction: alias "meta.isAction"
  preload: K
  presenter: alias "meta.options.presenter"
  isCustomized: apply "presenter", (presenter) -> typeof presenter is "string"
`export default FieldCoreMixin`
