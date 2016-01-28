`import Ember from 'ember'`
`import {_computed} from '../utils/xdash'`
`import _ from 'lodash/lodash'`
`import routeSplit from '../utils/route-split'`

{match, apply} = _computed
{Mixin, isPresent, computed, inject, isArray, String} = Ember

Core =
  lookup: inject.service("lookup")
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
    modelName = model.constructor.modelName
    [prefix, uriName, suffix] = routeSplit @routeName
    [prefix, modelName, "index"].join(".")

  defaultModelCollection: ->
    @store.findAll @get "defaultModelName"

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
    switch action
      when "new", "edit"
        @workflow.setupCtx @, model, "new"
      else model

  modelCreated: (model) ->
    @transitionTo @defaultModelShowPath(model), model

  modelUpdated: (model) ->
    @modelCreated(model)

  modelDestroyed: (model) ->
    @modelCreated(model)

  cleanup: Ember.on "deactivate", ->
    model = @get "controller.model"
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
