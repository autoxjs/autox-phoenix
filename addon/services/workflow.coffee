`import Ember from 'ember'`
`import SchemaUtils from '../utils/schema'`
`import _ from 'lodash/lodash'`

{RSVP, Service, isArray, Object, Map, inject} = Ember
{isFunction: isF, merge} = _
isFactory = (x) ->
  isF(x?.eachAttribute) and isF(x?.eachRelationship)
  
WorkflowService = Service.extend
  lookup: inject.service("lookup")
  init: ->
    @grid = Map.create()

  setupCtx: (router, model, action) -> 
    if action is "index" and isArray(model)
      factory = model.get("firstObject.constructor")
      modelPath = router.defaultModelShowPath(model.get("firstObject"))
    else
      factory = model.constructor
      modelPath = router.defaultModelShowPath(model)
    return unless isFactory factory
    lookup = @get "lookup"
    ctx = {model, action, lookup, modelPath}
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
