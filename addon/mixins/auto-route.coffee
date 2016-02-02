`import Ember from 'ember'`
`import _x from '../utils/xdash'`
`import _ from 'lodash/lodash'`
`import {routeSplit, routeJoin} from '../utils/route-split'`

{isFunction} = _
{isntModel, computed: {match, apply}} = _x
{Mixin, isPresent, computed, inject, isArray, isBlank, String, A} = Ember

assertRoute = (router, name) ->
  if router.hasRoute name
    return name
  else
    throw """In the route for you tried to pass off '#{name}'
    as a route, but it wasn't one. Fix it, dumbass
    """
firstRouteable = (router, routeNames...) ->
  A(routeNames).find router.hasRoute.bind(router)

Core =
  lookup: inject.service("lookup")
  routing: inject.service("-routing")
  userHasDefinedTemplate: apply "lookup", "routeName", (lookup, routeName) ->
    isPresent lookup.template routeName
  .readOnly()
  routeAction: match "routeName",
    [/edit$/, -> "edit"],
    [/new$/, -> "new"],
    [/index$/, -> "index"],
    [_, ->]
  .readOnly()
  defaultModelName: match "routeName",
    [/([-\d\w]+)\.\w+$/, ([_, name]) -> String.singularize name],
    [_, ->]
  .readOnly()
  
  defaultModelShowPath: (model) ->
    factory = model?.constructor
    return if isBlank factory
    routeName = factory?.aboutMe?.routeName
    return assertRoute(@get("routing"), routeName(@, model)) if isFunction(routeName)
    return assertRoute(@get("routing"), routeName) if isPresent routeName
    return if routeName is false
    modelName = factory?.modelName
    return if isBlank modelName
    [prefix, uriName, suffix] = routeSplit @routeName
    firstRouteable @get("routing"),
      routeJoin([prefix, uriName, modelName, "index"]),
      routeJoin([prefix, modelName, "index"])

  defaultModelCollection: ->
    modelName = @get "defaultModelName"
    @store.findAll modelName if isPresent(modelName) and typeof modelName is "string"

  model: (params) ->
    action = @get("routeAction")
    switch action
      when "new"
        modelName = @get "defaultModelName"
        @store.createRecord modelName
      when "index"
        @_super(arguments...) ? @defaultModelCollection(params)
      else @_super arguments...

  afterModel: (model) ->
    action = @get("routeAction")
    if action in ["new", "edit", "index"] and model?
      action = "show" if action is "index" and model.id?
      @workflow.setupCtx @, model, action

  modelCreated: (model) ->
    path = @defaultModelShowPath(model)
    @transitionTo path, model if isPresent path

  modelUpdated: (model) ->
    @modelCreated(model)

  modelDestroyed: (model) ->
    @modelCreated(model)

  cleanup: Ember.on "deactivate", ->
    model = @get "controller.model"
    return if isntModel(model)
    model.rollbackAttributes() if model?.get "hasDirtyAttributes"
    @workflow.cleanCtx(model, @get("routeAction"))

  renderTemplate: (controller, model) ->
    return @_super(arguments...) if @get("userHasDefinedTemplate")
    action = @get "routeAction"
    if action in ["index", "edit", "new"]
      action = "show" if action is "index" and not isArray(model)
      @render "autox/#{action}", {controller, model}
    else
      @_super arguments...

  actions:
    "new": (model) ->
      model.save().then @modelCreated.bind(@)

    "edit": (model) ->
      model.save().then @modelUpdated.bind(@)

    "destroy": (model) ->
      model.destroyRecord().then @modelDestroyed.bind(@)

AutoRouteMixin = Mixin.create Core

`export {Core}`
`export default AutoRouteMixin`
