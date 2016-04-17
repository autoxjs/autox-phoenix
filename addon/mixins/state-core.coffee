`import Ember from 'ember'`
`import _x from 'autox/utils/xdash'`
`import { task, timeout } from 'ember-concurrency'`
`import {RouteData} from 'autox/utils/router-dsl'`

{A, RSVP, isBlank, computed: {alias, or: ifAny}} = Ember
{computed: {apply}} = _x

restartableTask = (f) -> task(f).restartable()

StateCoreMixin = Ember.Mixin.create
  linkSlug: ifAny "meta.options.linkSlug", "defaultLinkSlug"
  defaultLinkSlug: apply "routeName", "relationKind", "type", (routeName, kind, type) ->
    switch
      when kind is "hasMany" and (path = RouteData.childrenRoute type, routeName)?
        type: "hasManyChildren"
        path: path
      when kind is "hasMany" and (path = RouteData.collectionRoute type, routeName)?
        type: "hasMany"
        path: path
      when kind is "belongsTo" and (path = RouteData.childRoute type, routeName)?
        type: "belongsToChild"
        path: path
      when kind is "belongsTo" and (path = RouteData.modelRoute type, routeName)?
        type: "belongsTo"
        path: path

  routeAction: alias "ctx.routeAction"
  modelPath: alias "ctx.modelPath"
  routeName: alias "ctx.routeName"
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
