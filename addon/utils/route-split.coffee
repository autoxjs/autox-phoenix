`import Ember from 'ember'`
`import _x from './xdash'`
`import _ from 'lodash/lodash'`
{consumeEnd} = _x
{initial, last, trimLeft, partialRight} = _
{A, isPresent} = Ember
p = partialRight trimLeft, "."
routeSplit = (string) ->
  [ok, string, suffix] = consumeEnd(string, ".edit")
  [ok, string, suffix] = consumeEnd(string, ".new") unless ok
  [ok, string, suffix] = consumeEnd(string, ".index") unless ok

  x = string.split(".")
  prefix = initial(x).join(".")
  uriName = last x
  suffix = if ok then p(suffix) else ""
  [prefix, uriName, suffix]

routeJoin = (array) ->
  A array
  .filter(isPresent)
  .join(".")

`export {routeJoin, routeSplit}`
`export default routeSplit`
