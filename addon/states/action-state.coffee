`import Ember from 'ember'`
`import StateCore from '../mixins/state-core'`
`import ActionNeed from '../models/action-need'`
`import _x from 'autox/utils/xdash'`
`import _ from 'lodash/lodash'`
`import {Macros} from 'ember-cpm'`
{join} = Macros
{RSVP, set, computed} = Ember
{alias, map, not: none} = computed
{computed: {apply}} = _x
{isEqual, tap, identity, partialRight} = _

fetchGoods = (hash, need) ->
  tap hash, partialRight(set, need.get("modelName"), need.get("preparedGoods"))

ActionState = Ember.ObjectProxy.extend StateCore,
  debugName: join "modelName", "name", "status", "#"
  status: computed "allFulfilled", "isComplete", "activeModelname", ->
    switch
      when @get "isComplete" then "complete"
      when @get "allFulfilled" then "fulfilled"
      else "needs-#{@get "activeModelname"}"
  needs: map "needCores", (core) -> ActionNeed.create core
  activeNeed: apply "needs", "activeIndex", (needs, i) -> needs.objectAt i
  allFulfilled: apply "activeIndex", "needs.length", isEqual
  needsDeps: none "allFulfilled"
  activeModelname: alias "activeNeed.modelName"
  results: null
  isComplete: false
  activeIndex: 0
  destruct: ->
    @get "needs"
    .reduce fetchGoods, {}

  complete: (results) ->
    tap @, =>
      @set "isComplete", true
      @set "results", results
  stillNeeds: (good) ->
    @get("needsDeps") and @get("activeNeed").stillNeeds good
  fulfillNextNeed: (good) ->
    tap @, =>
      isFulfilled = @get "activeNeed"
      .fulfill(good)
      .get "isFulfilled"
      @incrementProperty "activeIndex" if isFulfilled

  reset: ->
    tap @, =>
      @set "isComplete", false
      @set "activeIndex", 0
      @get "needs"
      .map (need) -> need.reset()

  setupArgs: ->
    @getWithDefault "setup", identity
    .call @get("model"), @
  performAction: (args) ->
    model = @get("model")
    model
    .get @get "name"
    .call model, args
  invokeAction: ->
    switch
      when @get("allFulfilled")
        RSVP.resolve @setupArgs()
        .then (args) =>
          @performAction(args)
        .then (results) =>
          state: @complete(results)
      when @stillNeeds @get "model"
        RSVP.resolve @setupArgs()
        .then (args) =>
          @performAction(args)
        .then (state) -> {state}
      else
        RSVP.resolve state: @reset()

`export default ActionState`