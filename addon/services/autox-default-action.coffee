`import Ember from 'ember'`
`import {RouteData} from 'autox/utils/router-dsl'`

AutoxDefaultActionService = Ember.Service.extend
  handle: (ctrl, field, actionState) ->
    switch
      when actionState.get("isComplete") and field.get("bubbles")
        ctrl.send field.get("bubbles"), actionState.get("results")
      when actionState.get("needsDeps")
        @handleDependencyTransition ctrl, actionState
    
  handleDependencyTransition: (ctrl, actionState) ->
    if (link = RouteData.collectionRoute actionState.get "activeModelname")?
      ctrl.transitionToRoute link

  create: (ctrl, model) ->
    model.save().then (model) -> ctrl.send "modelCreated", model

  update: (ctrl, model) ->
    model.save().then (model) -> ctrl.send "modelUpdated", model

  obliterate: (ctrl, model) ->
    model.destroyRecord().then -> ctrl.send "modelDestroyed", model

`export default AutoxDefaultActionService`
