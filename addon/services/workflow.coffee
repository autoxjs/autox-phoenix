`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
`import _x from '../utils/xdash'`
{hasFunctions, computed: {apply}} = _x
{RSVP, Service, isBlank, isArray, isEmpty, Object, Map, inject, assert} = Ember
{isFunction: isF, merge, chain, partialRight, invoke} = _
isFactory = (x) ->
  isF(x?.eachAttribute) and isF(x?.eachRelationship)
  
WorkflowService = Service.extend
  lookup: inject.service("lookup")

  setupMeta: ({routeAction, modelName, modelPath, model}) ->
    return if isBlank(modelName) or isBlank(routeAction)
    collection = @get("lookup").other "field:#{modelName}"
    return if isBlank(collection) 
    return if isEmpty(fields = collection.get "sortedFields")
    chain(fields)
    .tap (fields) -> assert "is a proper array", isArray(fields)
    .map (field) -> field.initState {routeAction, model}
    .thru RSVP.all
    .value()
    .then (fields) ->
      {fields, routeAction, modelPath}

`export default WorkflowService`
