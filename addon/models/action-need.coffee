`import Ember from 'ember'`
`import {_computed} from '../utils/xdash'`
`import _ from 'lodash/lodash'`
`import {Macros} from 'ember-cpm'`
{conditional} = Macros
{apply} = _computed
{isEqual, tap} = _
{A, computed: {alias, gt, equal}} = Ember
ActionNeed = Ember.Object.extend
  init: ->
    @_super arguments...
    @reset()
  isFulfilled: apply "goods.length", "amount", isEqual
  isPlural: gt "amount", 1
  isSingle: equal "amount", 1
  preparedGoods: conditional "isPlural", "goods", "good"
  good: alias "goods.firstObject"
  destruct: ->
    tap {}, (output) =>
      output[@get "modelName"] = if @get("isSingle") then @get("good") else @get("goods")
  fulfill: (good) ->
    @get("goods").pushObject good
    @

  stillNeeds: (good) ->
    not @get("isFulfilled") and 
    good?.constructor?.modelName is @get("modelName")

  reset: ->
    @set "goods", A []

`export default ActionNeed`