`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
`import ActionNeed from '../models/action-need'`

{tap, isNaN, isFunction, merge} = _
{K, isBlank, A} = Ember

action = (type, options={}, f) ->
  options.generator ?= f
  Ember
  .computed -> f
  .meta({type, options, isAction: true})
  .readOnly()

makeYielder = ({modelName, amount}) ->
  need = ActionNeed.create {modelName, amount}
  until need.get("isFulfilled")
    need.fulfill yield need
  need

action.need = (needName) ->
  need = yield from makeYielder parse needName 
  need.destruct()

action.needs = (requirements...) ->
  output = {}
  for req in requirements
    good = yield from action.need req
    merge output, good
  output

parse = (req) ->
  [modelName, amount] = req.split(":")
  n = parseInt(amount)
  switch
    when isBlank(amount) or isNaN(n) then {modelName, amount: 1}
    else {modelName, amount: n}
`export default action`
