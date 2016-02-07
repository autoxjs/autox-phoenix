`import Ember from 'ember'`
`import _x from '../utils/xdash'`
{A, K, computed: {alias, or: ifAny}} = Ember
{computed: {apply}} = _x

FieldCoreMixin = Ember.Mixin.create
  lookup: alias "ctx.lookup"
  action: alias "ctx.action"
  accessName: ifAny "aliasKey", "name"
  aliasKey: alias "meta.options.aliasKey"
  type: alias "meta.type"
  label: ifAny "meta.options.label", "name"
  priority: alias "meta.options.priority"
  description: alias "meta.options.description"
  
  canOnlyDisplay: apply "meta.options.display", "action", (xs, x) -> A(xs).contains x
  canModify: apply "meta.options.modify", "action", (xs, x) -> A(xs).contains x
  isRelationship: alias "meta.isRelationship"
  isAttribute: alias "meta.isAttribute"
  isVirtual: alias "meta.isVirtual"
  isAction: alias "meta.isAction"

  preload: K
`export default FieldCoreMixin`
