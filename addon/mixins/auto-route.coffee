`import Ember from 'ember'`
`import _x from '../utils/xdash'`
`import _ from 'lodash/lodash'`
`import {routeSplit, routeJoin} from '../utils/route-split'`
`import {RouteData} from '../utils/router-dsl'`

{isFunction, last, flow, trimRight, partialRight, invoke, chain, merge, tap, set} = _
{isntModel, tapLog, computed: {apply}} = _x
{Mixin, isPresent, computed, inject, isArray, isBlank, String, A, RSVP} = Ember

assertRoute = (router, name) ->
  if router.hasRoute name
    return name
  else
    throw """In the route for you tried to pass off '#{name}'
    as a route, but it wasn't one. Fix it, dumbass
    """

collectionParentName = flow partialRight(trimRight, ".index"),
  (x) -> x.split("."),
  (xs) -> xs.join("/")

firstRouteable = (router, routeNames...) ->
  A(routeNames).find router.hasRoute.bind(router)

Core =
  paginateParams: inject.service("paginate-params")
  lookup: inject.service("lookup")
  routing: inject.service("-routing")
  userHasDefinedTemplate: apply "lookup", "routeName", (lookup, routeName) ->
    isPresent lookup.template routeName
  
  routeAction: apply "routeName", RouteData.routeAction
  defaultModelName: apply "routeName", RouteData.routeModel
  defaultModelFactory: apply "store", "defaultModelName", (store, name) ->
    store.modelFor(name) if isPresent(name)

  defaultModelShowPath: (factory) ->
    factory ?= @get "defaultModelFactory"
    routeName = factory?.aboutMe?.routeName
    return assertRoute(@get("routing"), routeName(@, model)) if isFunction(routeName)
    return assertRoute(@get("routing"), routeName) if isPresent routeName
    return if routeName is false
    RouteData.modelRoute factory?.modelName, @routeName

  parentNodeRoute: ->
    RouteData.parentNodeRoute @routeName
  parentNodeModel: ->
    @modelFor route if isPresent(route = @parentNodeRoute())

  beforeModel: ->
    @_super arguments...
    @get("paginateParams").pushRoute @

  defaultNewParams: (relationName, params={}) ->
    model = @parentNodeModel()
    factory = model?.constructor
    modelName = factory?.inverseFor(String.camelize relationName)?.name
    modelName ?= factory?.modelName
    params[modelName] = model if modelName?
    params
  model: (params) ->
    @get("paginateParams").manualUpdate params
    switch @get("routeAction")
      when "collection#new"
        @store.createRecord @get("defaultModelName"), params
      when "children#new"
        [..., relationName, _new] = @routeName.split(".")
        @store.createRecord @get("defaultModelName"),
          @defaultNewParams(relationName, params)
      when "model#children", "model#child"
        relationName = last @routeName.split(".")
        @parentNodeModel()?.get relationName
      when "model#collection"
        modelName = @get "defaultModelName"
        collectionName = last @routeName.split(".")
        query = @get("paginateParams.activeQuery")
        params = merge query.toParams(), 
          belongsTo: @parentNodeModel()
        @store
        .query(modelName, params)
      when "namespace#collection", "collection"
        modelName = @get "defaultModelName"
        query = @get("paginateParams.activeQuery")
        @store
        .query(modelName, query.toParams())
      else 
        @_super arguments...

  afterModel: (model) ->
    return unless model?
    meta = @workflow?.setupMeta
      model: model
      modelPath: @defaultModelShowPath()
      modelName: @get "defaultModelName"
      routeAction: @get("routeAction")
      routeName: @routeName
    RSVP.resolve meta
    .then (meta) => 
      model.dirtyMetaTempStore = meta

  setupController: (controller, model) ->
    controller.set("meta", model.dirtyMetaTempStore) if model?.dirtyMetaTempStore?
    @_super controller, model

  modelCreated: (model) ->
    path = @defaultModelShowPath(model.constructor)
    @transitionTo path, model if isPresent path

  modelUpdated: (model) ->
    @modelCreated(model)

  modelDestroyed: (model) ->
    @modelCreated(model)

  deactivate: ->
    model = @get("controller.model")
    return if isntModel(model)
    model.rollbackAttributes() if model?.get "hasDirtyAttributes"
    @_super arguments...

  renderTemplate: (controller, model) ->
    return @_super(arguments...) if @get("userHasDefinedTemplate")
    switch @get "routeAction"
      when "model#index", "model#child"
        @render "autox/show", {controller, model}
      when "model#edit" 
        @render "autox/edit", {controller, model}
      when "collection#index", "children#index"
        @render "autox/index", {controller, model}
      when "collection#new", "children#new"
        @render "autox/new", {controller, model}
      else 
        @_super arguments...

  actions:
    modelCreated: -> @modelCreated arguments...
    modelUpdated: -> @modelUpdated arguments...
    modelDestroyed: -> @modelDestroyed arguments...

AutoRouteMixin = Mixin.create Core

`export {Core}`
`export default AutoRouteMixin`
