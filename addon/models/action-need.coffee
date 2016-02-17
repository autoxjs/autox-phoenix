`import Ember from 'ember'`

{A, computed: {equal}} = Ember
ActionNeed = Ember.Object.extend
  init: ->
    @_super arguments...
    @reset()
  isFulfilled: equal "goods.length", "amount"
  fulfill: (good) ->
    @get("goods").pushObject good
    @

  stillNeeds: (good) ->
    not @get("isFulfilled") and 
    good?.constructor?.modelName is @get("modelName")

  reset: ->
    @set "goods", A []

`export default ActionNeed`