`import Ember from 'ember'`
`import _ from 'lodash/lodash'`

{keys, partial, partialRight, merge, mapValues, chain, clone} = _
{RSVP, get} = Ember

identify = (model) ->
  mentionedType: model.constructor.modelName
  mentionedId: get(model, "id")
  scheduledAt: moment()
  happenedAt: moment()

typeify = (models) ->
  switch keys(models).length
    when 1 then type: "single"
    when 2 then type: "pair"
    else throw """
    I expected either a l1 tuple or an l2 tuple, but you passed in some much more complicated horseshit
    """
      
rotateValues = (params) ->
  firstKey = null
  for key, value of params
    firstKey ?= key
    params[key] = lastValue
    lastValue = value
  params[firstKey] = lastValue if firstKey?
  params

mergeWith = (target, source, f) ->
  for key, value of source
    target[key] = f(target[key], value)
  target

historify = (common, models, model) ->
  chain(common)
  .clone()
  .merge(typeify models)
  .merge(identify model)
  .value()

toTuple = (a,b) -> [a,b]
associateHistory = ([params, model]) -> model.relate("histories").associate(params)
createHistory = (common, models) ->
  chain(models)
  .mapValues(partial historify, common, models)
  .tap(rotateValues)
  .tap(partialRight mergeWith, models, toTuple)
  .mapValues(associateHistory)
  .value()

persistHistory = (common, models) ->
  chain(createHistory common, models)
  .mapValues (x) -> x.save()
  .tap(RSVP.hash)
  .value()

`export {createHistory, associateHistory, historify, rotateValues, persistHistory}`
`export default createHistory`
