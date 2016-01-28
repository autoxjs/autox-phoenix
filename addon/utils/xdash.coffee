`import _ from 'lodash/lodash'`
`import Ember from 'ember'`

{isPresent, computed, A} = Ember
{trimRight, endsWith, isEqual, isFunction, isRegExp, isString, map} = _

consumeEnd = (string, substr) ->
  if (isOk = endsWith(string, substr))
    string = trimRight string, substr
  [isOk, string, substr]

noMatchError = (value) -> "Nothing matched `#{value}`"
match = (value, [matcher, action], matchPairs...) ->
  throw noMatchError(value) unless action?
  [isEq, newVal] = matchEqual(matcher, value)
  if isEq
    action(newVal)
  else
    match(value, matchPairs...)

matchEqual = (matcher, value) ->
  return [true, value] if matcher is _
  return [matcher is value, value] if typeof matcher in ["number", "string"]
  return matcher(value) if isFunction(matcher)
  if isRegExp(matcher) and isString(value)
    results = matcher.exec(value) ? []
    return [isPresent(results), results]
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
        boundMatchers = A(matchers).map ([matcher, action]) => [matcher, action.bind(@)] 
        match @get(key), boundMatchers...

_x = {match, consumeEnd, computed: _computed}

`export {_computed, _x}`
`export default _x`