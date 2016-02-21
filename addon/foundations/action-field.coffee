`import Ember from 'ember'`
`import FieldFoundation from '../mixins/field-foundation'`
`import ActionState from '../states/action-state'`
`import _ from 'lodash/lodash'`
`import _x from 'autox/utils/xdash'`
`import {Macros} from 'ember-cpm'`

{computed: {apply}} = _x
{conditional} = Macros
{identity, chain, partialRight, tap, isFunction} = _
{RSVP, inject, set, String, Object, computed: {oneWay, alias, equal}} = Ember

ActionField = Object.extend FieldFoundation,
  bubbles: alias "meta.options.bubbles"
  bubblesName: apply "bubbles", "name", (bubbles, defaultName) ->
    switch
      when typeof bubbles is "string" then bubbles
      when bubbles? then defaultName
  confirm: alias "meta.options.confirm"
  presenter: alias "meta.options.presenter"
  setup: alias "meta.options.setup"
  needCores: alias "meta.options.needCores"
  useCurrent: alias "meta.options.useCurrent"
  initState: (ctx) ->
    ActionState
    .extend
      when: @getWhen()
    .create {ctx, content: @}
    .preload()

  hackState: (ctx) ->
    RSVP.resolve @get("fsm.currentAction")

`export default ActionField`
