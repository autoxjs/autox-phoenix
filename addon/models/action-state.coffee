`import Ember from 'ember'`
`import {_computed} from '../utils/xdash'`
`import ActionNeed from './action-need'`
`import _ from 'lodash/lodash'`
{isEqual} = _
{computed: {map, alias, not: none}} = Ember
{apply} = _computed
ActionState = Ember.Object.extend
  needs: map "needCores", (core) -> ActionNeed.create core
  activeNeed: apply "needs", "activeIndex", (needs, i) -> needs.objectAt i
  allFulfilled: apply "activeIndex", "needs.length", isEqual
  needsDeps: none "allFulfilled"
  activeModelname: alias "activeNeed.modelname"

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

    if isFulfilled
      @incrementProperty "activeIndex"
  reset: ->
    @set "isComplete", false
    @set "activeIndex", 0
    @get "needs"
    .map (need) -> need.reset()
    @

`export default ActionState`