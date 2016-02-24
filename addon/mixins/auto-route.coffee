`import Ember from 'ember'`
`import _x from '../utils/xdash'`
`import _ from 'lodash/lodash'`
`import {routeSplit, routeJoin} from '../utils/route-split'`
`import {RouteData} from '../utils/router-dsl'`
{isFunction, last} = _
{isntModel, computed: {apply}} = _x
{Mixin, isPresent, computed, inject, isArray, isBlank, String, A, RSVP} = Ember

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
  dirtyMetaTempStore: null
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
    RouteData.modelRoute factory?.modelName

  parentNodeRoute: ->
    RouteData.parentNodeRoute @routeName
  parentNodeModel: ->
    @modelFor route if (route = @parentNodeRoute())?

  model: (params) ->
    switch @get("routeAction")
      when "collection#new"
        @store.createRecord @get "defaultModelName"
      when "model#collection"
        collectionName = last @routeName.split(".")
        getWithDefault @parentNodeModel(), collectionName, A []
      when "namespace#collection", "collection"
        modelName = @get "defaultModelName"
        @store.findAll modelName
      else 
        @_super arguments...

  afterModel: (model) ->
    return unless model?
    meta = @workflow?.setupMeta
      model: model
      modelPath: @defaultModelShowPath()
      modelName: @get "defaultModelName"
      routeAction: @get("routeAction")
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

  cleanup: Ember.on "deactivate", ->
    model = @get("controller.model")
    return if isntModel(model)
    model.rollbackAttributes() if model?.get "hasDirtyAttributes"

  renderTemplate: (controller, model) ->
    return @_super(arguments...) if @get("userHasDefinedTemplate")
    switch @get "routeAction"
      when "model#index" 
        @render "autox/show", {controller, model}
      when "model#edit" 
        @render "autox/edit", {controller, model}
      when "collection#index" 
        @render "autox/index", {controller, model}
      when "collection#new" 
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
