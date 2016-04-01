`import Ember from 'ember'`
`import _x from 'autox/utils/xdash'`
`import { task, timeout } from 'ember-concurrency'`

{A, RSVP, isBlank, computed: {alias, or: ifAny}} = Ember
{computed: {apply}} = _x

restartableTask = (f) -> task(f).restartable()

StateCoreMixin = Ember.Mixin.create
  routeAction: alias "ctx.routeAction"
  model: alias "ctx.model"
  modelName: alias "model.constructor.modelName"
  choices: null
  ctx: null
  canOnlyDisplay: apply "displayers", "routeAction", (xs, x) -> A(xs).contains x
  canDisplay: ifAny "canOnlyDisplay", "canModify"
  canModify: apply "modifiers", "routeAction", (xs, x) -> A(xs).contains x
  search: apply "meta.options.search", "model", (f, m) ->
    f.bind(m) if f? and m?
  searchTask: restartableTask (term) ->
    return [] if isBlank term
    yield timeout 500
    return yield @get("search")?(term)

  preload: -> RSVP.resolve @
`export default StateCoreMixin`
