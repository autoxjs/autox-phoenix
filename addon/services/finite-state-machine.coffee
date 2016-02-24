`import Ember from 'ember'`
{A, computed, Service} = Ember
{alias} = computed
FiniteStateMachineService = Service.extend
  states: A([])
  depth: 2
  wasA: (modelName) ->
    modelName? and @get("prev")?.constructor?.modelName is modelName
  currentAction: alias "prev"
  prev: computed "states.[]", "depth",
    get: ->
      @states.get "lastObject"
    set: (_, value) ->
      while @states.get("length") >= @get("depth")
        @states.shiftObject()
      @states.pushObject value

  reset: ->
    @states.clear()
    @

`export default FiniteStateMachineService`
