`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
`import ActionNeed from '../models/action-need'`
`import _x from './xdash'`
{tap, isNaN, isFunction, merge} = _
{K, isBlank, A} = Ember

errMsg = (o, f) -> """
You passed in an action function: #{f}
which was not a generator when we expected one.
The options passed to this action are:

#{o}
"""

action = (type, options={}, f) ->
  unless _x.isGenerator f
    throw new Error errMsg(options, f)
  options.generator ?= f
  Ember
  .computed -> f
  .meta({type, options, isAction: true})
  .readOnly()

makeYielder = ({modelName, fulfillmentPath, amount}) ->
  need = ActionNeed.create {modelName, fulfillmentPath, amount}
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
  [modelName, amount, fulfillmentPath] = req.split(":")
  n = parseInt(amount)
  switch
    when isBlank(amount) or isNaN(n) then {modelName, fulfillmentPath, amount: 1}
    else {modelName, fulfillmentPath, amount: n}
`export default action`
