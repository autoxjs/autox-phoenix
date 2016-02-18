`import Ember from 'ember'`
`import FieldCore from '../mixins/field-core'`
`import _ from 'lodash/lodash'`
`import _x from 'autox/utils/xdash'`
`import {Macros} from 'ember-cpm'`

{computed: {apply}} = _x
{conditional} = Macros
{identity, chain, partialRight, tap, isFunction} = _
{RSVP, set, String, Object, computed: {oneWay, alias, equal}} = Ember

ActionField = Object.extend FieldCore,
  fsm: alias "ctx.fsm"
  bubbles: alias "meta.options.bubbles"
  bubblesName: apply "bubbles", "name", (bubbles, defaultName) ->
    switch
      when typeof bubbles is "string" then bubbles
      when bubbles? then defaultName
  confirm: alias "meta.options.confirm"
  presenter: alias "meta.options.presenter"
  setup: alias "meta.options.setup"
  canDisplay: oneWay "canOnlyDisplay"
  naiveActionState: alias "meta.options.actionState"
  actionState: apply "useHack", "currentAction", "naiveActionState", (x,y,z) -> if x then y else z
  useHack: equal "meta.options.useHack", "just-fucking-do-it-i-dont-care"
  currentAction: alias "fsm.currentAction"
  needsAreFulfilled: alias "actionState.allFulfilled"

  getWhen: -> @get("meta.options")?.when
  setupArgs: (model) ->
    actionState = tap @get("actionState"), partialRight(set, "fsm", @get "fsm")
    @getWithDefault "setup", identity
    .call model, actionState
  performAction: (model, args) ->
    model.get @get "name"
    .call model, args
  invokeAction: (model) ->
    switch
      when @get("needsAreFulfilled")
        RSVP.resolve @setupArgs(model)
        .then (args) =>
          @performAction(model, args)
        .then (results) =>
          state: @get("actionState").complete(results)
      when @get("actionState")?.stillNeeds model
        RSVP.resolve @setupArgs(model)
        .then (args) =>
          @performAction(model, args)
        .then (state) -> {state}
      else
        RSVP.resolve state: @get("actionState").reset(model)

`export default ActionField`
