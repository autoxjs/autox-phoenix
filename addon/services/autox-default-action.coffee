`import Ember from 'ember'`
`import {RouteData} from 'autox/utils/router-dsl'`

inferRoute = (state) -> 
  return path if (path = state.get "fulfillmentPath")?
  anchorRoute = state.get "modelPath"
  modelName = state.get "activeModelname"
  RouteData.collectionRoute modelName, anchorRoute
gohome = (state) ->
  anchorRoute = state.get "modelPath"
  modelName = state.get "modelName"
  route = RouteData.modelRoute modelName, anchorRoute
  model = state.get("model")
  return [route, model] if route? and model?

handleComplexAction = (ctrl, field, actionState) ->
  ctrl.get("fsm.currentAction")
  .fulfillNextNeed actionState.get("payload")
  .then (currentState) ->
    switch
      when currentState.get("isNeedy") and (link = inferRoute currentState)?
        ctrl.transitionToRoute link
      when currentState.get("isNeedy")
        throw new Error "Unable to infer where to go to fulfill #{currentState.get "debugName"}"
      when currentState.get("isComplete") and (name = currentState.get "bubblesName")?
        ctrl.send name, currentState.get("payload")
      when currentState.get("isComplete") and (link = gohome currentState)?
        ctrl.transitionToRoute link...
      when currentState.get("isComplete")
        throw new Error "Unsure what to do after completing #{currentState.get "debugName"}"
      when currentState.get("isFulfilled") and (link = gohome currentState)?
        ctrl.transitionToRoute link...
      when currentState.get("isFulfilled")
        # Confirmation not implemented yet!
        throw new Error "Unsure where to go to receive confirmation to complete #{currentState.get "debugName"}"
      else throw new Error "Unsure what to do with #{currentState.get "debugName"}"
        
handleNaiveAction = (ctrl, field, actionState) ->
  Ember.RSVP.resolve actionState
  .then (resultState) ->
    switch
      when resultState.get("isComplete") and (name = resultState.get "bubblesName")?
        ctrl.send name, resultState.get("payload")
      when resultState.get("isNeedy") and (link = inferRoute resultState)?
        ctrl.get("fsm").set "prev", resultState
        ctrl.transitionToRoute link
      when resultState.get("isNeedy")
        throw new Error "Unable to infer where to go to start fulfilling #{currentState.get "debugName"}"
      when resultState.get("isFulfilled") and (link = gohome resultState)?
        ctrl.transitionToRoute link...
AutoxDefaultActionService = Ember.Service.extend    
  handle: (ctrl, field, actionState) ->
    if actionState.get("useCurrent")
      handleComplexAction(ctrl, field, actionState)
    else
      handleNaiveAction(ctrl, field, actionState)

  create: (ctrl, model) ->
    model.save().then (model) -> ctrl.send "modelCreated", model

  update: (ctrl, model) ->
    model.save().then (model) -> ctrl.send "modelUpdated", model

  obliterate: (ctrl, model) ->
    model.destroyRecord().then -> ctrl.send "modelDestroyed", model

`export default AutoxDefaultActionService`
