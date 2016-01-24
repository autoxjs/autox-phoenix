`import _ from 'lodash/lodash'`
`import Ember from 'ember'`

{isEmpty, computed} = Ember
{isEqualWith, isEqual, isFunction, isRegExp, isString, map} = _

noMatchError = (value) -> "Nothing matched `#{value}`"
match = (value, matchPair, matchPairs...) ->
  throw noMatchError(value) unless matchPair?
  [matcher, action] = matchPair
  [isEq, newVal] = isEqualWith(matcher, value, matchEqual)
  if isEq
    action(newVal)
  else
    match(value, matchPairs)

matchEqual = (matcher, value) ->
  return [true, value] if matcher is _
  return [matcher is value, value] if typeof matcher in ["number", "string"]
  return matcher(value) if isFunction(matcher)
  if isRegExp(matcher) and isString(value)
    value = matcher.exec(value)[1...]
    return [isEmpty(value), value]
  return [isEqual(matcher, value), value]
  
_computed =
  access: (objKey, memKey) ->
    computed objKey, memKey,
      get: ->
        if (key = @get memKey)?
          @get "#{objKey}.#{key}"
  apply: (keys..., f) ->
    computed keys...,
      get: -> 
        xs = map keys, @get.bind(@)
        f xs...
  match: (key, matchers...) ->
    computed key,
      get: ->
        match @get(key), matchers...

_x = {match, computed: _computed}

`export {_computed, _x}`
`export default _x`