`import Ember from 'ember'`
`import {_computed} from '../utils/xdash'`
`import ActionNeed from './action-need'`
`import _ from 'lodash/lodash'`
{isEqual, tap, partialRight, set} = _
{computed: {map, alias, not: none}} = Ember
{apply} = _computed
fetchGoods = (hash, need) ->
  tap hash, partialRight(set, need.get("modelName"), need.get("preparedGoods"))
  
ActionState = Ember.Object.extend
  needs: map "needCores", (core) -> ActionNeed.create core
  activeNeed: apply "needs", "activeIndex", (needs, i) -> needs.objectAt i
  allFulfilled: apply "activeIndex", "needs.length", isEqual
  needsDeps: none "allFulfilled"
  activeModelname: alias "activeNeed.modelName"

  destruct: ->
    @get "needs"
    .reduce fetchGoods, {}
  init: ->
    @_super arguments...
    @reset()
  complete: (results) ->
    @set "isComplete", true
    @set "results", results
    @
  stillNeeds: (good) ->
    @get("needsDeps") and @get("activeNeed").stillNeeds good
  fulfillNextNeed: (good) ->
    isFulfilled = @get "activeNeed"
    .fulfill(good)
    .get "isFulfilled"
    @incrementProperty "activeIndex" if isFulfilled

    @
  reset: (model) ->
    @set "model", model
    @set "isComplete", false
    @set "activeIndex", 0
    @get "needs"
    .map (need) -> need.reset()
    @
  

`export default ActionState`