`import Ember from 'ember'`
`import _ from 'lodash/lodash'`

{tap, isNaN, isFunction} = _
{K, isBlank, A} = Ember

action = (type, options={}, f) ->
  [f, needCores] = switch
    when isFunction(f) then [f, []]
    when isBlank(f) then [K, []]
    else [f.f, f.needCores]
  options.needCores ?= needCores
  Ember
  .computed -> f
  .meta({type, options, isAction: true})
  .readOnly()

action.needs = (requirements..., f) ->
  tap {f}, (reqs) ->
    reqs.needCores = A(requirements).map parse

parse = (req) ->
  [modelName, amount] = req.split(":")
  n = parseInt(amount)
  switch
    when isBlank(amount) or isNaN(n) then {modelName, amount: 1}
    else {modelName, amount: n}
`export default action`
