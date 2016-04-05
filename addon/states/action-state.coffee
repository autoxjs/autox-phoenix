`import Ember from 'ember'`
`import StateCore from '../mixins/state-core'`
`import ActionNeed from '../models/action-need'`
`import _x from 'autox/utils/xdash'`
`import _ from 'lodash/lodash'`
`import {Macros} from 'ember-cpm'`
{join} = Macros
{A, RSVP, isBlank, set, computed} = Ember
{alias, equal, map, or: firstPresent, not: none} = computed
{tapLog, computed: {apply}} = _x
{isEqual, tap, identity, partialRight, chain} = _

ActionState = Ember.ObjectProxy.extend StateCore,
  debugName: join "modelName", "name", "status", "#"
  status: "virgin"
  activeModelname: alias "activeNeed.modelName"
  activeNeed: null
  payload: null
  fulfillmentPath: alias "activeNeed.fulfillmentPath"
  isComplete: equal "status", "complete"
  isFulfilled: equal "status", "fulfilled"
  isVirgin: equal "status", "virgin"
  isNeedy: equal "status", "needy"
  iterator: null

  init: ->
    @_super arguments...
    @reset()

  complete: (payload) ->
    tap @, =>
      @set "status", "complete"
      @set "payload", payload

  stillNeeds: (good) ->
    @get("isNeedy") and @get("activeNeed").stillNeeds good

  fulfillNextNeed: (good) ->
    @promiseInvokation @iterator.next good
    .then => @

  reset: ->
    tap @, =>
      @iterator = @get("generator").call @get("model"), @
      @set "status", "virgin"
      @set "activeNeed", null

  nextDeps: (need) ->
    tap @, =>
      @set "status", "needy"
      @set "activeNeed", need

  requireConfirmation: ->
    tap @, => @set "status", "fulfilled"

  invokeAction: ->
    @reset() if @get("isComplete")
    chain @iterator.next()
    .thru @promiseInvokation.bind(@)
    .value()

  promiseInvokation: ({value, done}) ->
    state = RSVP.resolve switch
      when done is true
        RSVP.resolve(value)
        .then (result) => @complete(result)
      when value instanceof ActionNeed 
        @nextDeps(value)
      when isBlank(value) 
        @requireConfirmation()
      else
        throw new Error "Unsure wtf you're trying to do"
    RSVP.hash {state}

`export default ActionState`