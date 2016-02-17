`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
`import ActionState from '../models/action-state'`
{merge, tap, isNaN, isFunction} = _
{K, isBlank, A} = Ember

action = (type, options={}, f) ->
  [f, actionState] = switch
    when isFunction(f) then [f, ActionState.create(needCores: [])]
    when isBlank(f) then [K, ActionState.create(needCores: [])]
    else [f.f, f.actionState]
  options.actionState ?= actionState
  Ember
  .computed -> f
  .meta({type, options, isAction: true})
  .readOnly()

action.needs = (requirements..., f) ->
  tap {f}, (reqs) ->
    reqs.actionState = ActionState.create 
      needCores: A(requirements).map parse

parse = (req) ->
  [modelName, amount] = req.split(":")
  n = parseInt(amount)
  switch
    when isBlank(amount) or isNaN(n) then {modelName, amount: 1}
    else {modelName, amount: n}
`export default action`
