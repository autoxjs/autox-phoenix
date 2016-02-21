`import Ember from 'ember'`
`import {RouteData} from 'autox/utils/router-dsl'`

inferRoute = (state) -> RouteData.collectionRoute state.get "activeModelname"
gohome = (state) -> 
  route = RouteData.modelRoute state.get "modelName"
  model = state.get("model")
  return [route, model] if route? and model?
AutoxDefaultActionService = Ember.Service.extend
  handle: (ctrl, field, actionState) ->
    if actionState.get("useCurrent")
      actionState = ctrl.get("fsm.currentAction")
    switch
      when actionState.get("isComplete")
        if (name = field.get "bubblesName")?
          ctrl.send field.get("bubblesName"), actionState.get("results")
      when actionState.get("allFulfilled")
        if (link = gohome actionState)?
          ctrl.transitionToRoute link...
      when actionState.get("needsDeps")
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
