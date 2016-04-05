`import Ember from 'ember'`
`import FieldFoundation from '../mixins/field-foundation'`
`import ActionState from '../states/action-state'`
`import _ from 'lodash/lodash'`
`import _x from 'autox/utils/xdash'`
`import {Macros} from 'ember-cpm'`

{genLift, computed: {access, apply}} = _x
{conditional} = Macros
{identity, chain, partialRight, tap, isFunction} = _
{RSVP, inject, isPresent, set, String, Object, computed} = Ember
{oneWay, alias, equal} = computed

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
  rawGen: alias "meta.options.generator"
  generator: alias "rawGen"
  inAnotherAction: computed "fsm.currentAction.isComplete", "useCurrent", ->
    @get("useCurrent") isnt true and
    isPresent(@get "fsm.currentAction") and
    not @get("fsm.currentAction.isComplete")
  initState: (ctx) ->
    ActionState
    .extend
      when: @getWhen()
    .create {ctx, content: @}
    .preload()

  hackState: (ctx) ->
    RSVP.resolve @get("fsm.currentAction")

`export default ActionField`
