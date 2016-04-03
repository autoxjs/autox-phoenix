`import Ember from 'ember'`
`import {RouteData} from 'autox/utils/router-dsl'`

inferRoute = (state) -> 
  anchorRoute = state.get "modelPath"
  modelName = state.get "activeModelname"
  RouteData.collectionRoute modelName, anchorRoute
gohome = (state) ->
  anchorRoute = state.get "modelPath"
  modelName = state.get "modelName"
  route = RouteData.modelRoute modelName, anchorRoute
  model = state.get("model")
  return [route, model] if route? and model?

AutoxDefaultActionService = Ember.Service.extend
  handle: (ctrl, field, actionState) ->
    promiseState = if actionState.get("useCurrent")
      ctrl
      .get("fsm.currentAction")
      .fulfillNextNeed actionState.get("payload")
    else
      Ember.RSVP.resolve actionState
    promiseState.then (actionState) ->
      switch
        when actionState.get("isComplete")
          if (name = actionState.get "bubblesName")?
            ctrl.send name, actionState.get("payload")
        when actionState.get("isFulfilled")
          if (link = gohome actionState)?
            ctrl.transitionToRoute link...
        when actionState.get("isNeedy")
          ctrl.fsm.set("currentAction", actionState)
          if (link = inferRoute actionState)?
            ctrl.transitionToRoute link

  create: (ctrl, model) ->
    model.save().then (model) -> ctrl.send "modelCreated", model

  update: (ctrl, model) ->
    model.save().then (model) -> ctrl.send "modelUpdated", model

  obliterate: (ctrl, model) ->
    model.destroyRecord().then -> ctrl.send "modelDestroyed", model

`export default AutoxDefaultActionService`
