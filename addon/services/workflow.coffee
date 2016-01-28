`import Ember from 'ember'`
`import SchemaUtils from '../utils/schema'`

{RSVP, Service, Object, Map, inject} = Ember

WorkflowService = Service.extend
  lookup: inject.service("lookup")
  init: ->
    @grid = Map.create()

  setupCtx: (router, model, action) -> 
    lookup = @get "lookup"
    ctx = {model, action, lookup}
    factory = model.constructor
    fields = SchemaUtils
    .getFields({factory, ctx})
    .map (field) -> 
      field.preload(router, router.store, model)
    RSVP
    .all(fields)
    .then (fields) =>
      @grid.set model, Object.create({fields, model, action})
  fetchCtx: (model) ->
    @grid.get model
  cleanCtx: (model, action) ->

`export default WorkflowService`
