`import Ember from 'ember'`
`import SchemaUtils from '../utils/schema'`
`import _ from 'lodash/lodash'`
`import _x from '../utils/xdash'`
{computed: {apply}} = _x
{RSVP, Service, isBlank, isArray, Object, Map, inject} = Ember
{isFunction: isF, merge} = _
isFactory = (x) ->
  isF(x?.eachAttribute) and isF(x?.eachRelationship)
  
WorkflowService = Service.extend
  session: inject.service("session")
  fsm: inject.service("finite-state-machine")
  lookup: inject.service("lookup")
  baseCtx: apply "session", "fsm", "lookup", (session, fsm, lookup) -> {session, fsm, lookup}
  init: ->
    @grid = Map.create()

  setupCtx: (router, model, action) -> 
    return if isBlank(model)
    switch action
      when "collection#index"
        factory = model.get("firstObject.constructor")
        modelPath = router.defaultModelShowPath(model.get("firstObject"))
      when "model#index", "model#edit", "collection#new"
        factory = model.constructor
        modelPath = router.defaultModelShowPath(model)
    return unless isFactory factory
    ctx = merge {model, action, router, modelPath}, @get("baseCtx")
    fields = SchemaUtils
    .getFields({factory, ctx})
    .map (field) -> 
      field.preload(router, router.store, model)
    RSVP
    .all(fields)
    .then (fields) =>
      @grid.set model, Object.create(merge(ctx, {fields}))
  fetchCtx: (model) ->
    @grid.get model
  cleanCtx: (model, action) ->

`export default WorkflowService`
