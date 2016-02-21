`import Ember from 'ember'`
`import _x from 'autox/utils/xdash'`
{A, RSVP, computed: {alias, or: ifAny}} = Ember
{computed: {apply}} = _x

StateCoreMixin = Ember.Mixin.create
  routeAction: alias "ctx.routeAction"
  model: alias "ctx.model"
  modelName: alias "model.constructor.modelName"
  choices: null
  ctx: null
  canOnlyDisplay: apply "displayers", "routeAction", (xs, x) -> A(xs).contains x
  canDisplay: ifAny "canOnlyDisplay", "canModify"
  canModify: apply "modifiers", "routeAction", (xs, x) -> A(xs).contains x
  preload: -> RSVP.resolve @
`export default StateCoreMixin`
