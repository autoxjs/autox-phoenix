`import Ember from 'ember'`
`import FieldCore from '../mixins/field-core'`
`import _ from 'lodash/lodash'`
`import _x from 'autox/utils/xdash'`
`import {Macros} from 'ember-cpm'`

{computed: {apply}} = _x
{conditional} = Macros
{identity, chain} = _
{RSVP, String, Object, computed: {oneWay, alias}} = Ember

ActionField = Object.extend FieldCore,
  bubbles: alias "meta.options.bubbles"
  bubblesName: apply "bubbles", "name", (bubbles, defaultName) ->
    switch
      when typeof bubbles is "string" then bubbles
      when bubbles is false then null
      else defaultName
  confirm: alias "meta.options.confirm"
  presenter: alias "meta.options.presenter"
  setup: alias "meta.options.setup"
  canDisplay: oneWay "canOnlyDisplay"
  actionState: alias "meta.options.actionState"
  needsAreFulfilled: alias "actionState.allFulfilled"

  getWhen: -> @get("meta.options")?.when
  setupArgs: (model) ->
    @getWithDefault "setup", identity
    .call model, @get("actionState")
  performAction: (model, args) ->
    model.get @get "name"
    .call model, args
  invokeAction: (model) ->
    if @get("needsAreFulfilled")
      RSVP.resolve @setupArgs(model)
      .then (args) =>
        @performAction(model, args)
      .then (results) =>
        state: @get("actionState").complete(results)
    else
      RSVP.resolve state: @get("actionState").reset()

`export default ActionField`
