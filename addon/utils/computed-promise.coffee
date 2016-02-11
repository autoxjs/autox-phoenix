`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
{chain} = _
{isBlank, RSVP, computed} = Ember
resolution = (results, fn, key) ->
  return if @get("isDestroyed") or @get("isDestroying")
  if isBlank results.promise    
    results.promise = (promise = RSVP.resolve fn.call @)
    promise.then (value) =>
      results.value = value
      delete results.promise
      @notifyPropertyChange key

computedPromise = (depKeys..., fn) ->
  missingObserver = true
  results = {}
  computed depKeys..., (key) ->
    if missingObserver
      f = chain(resolution)
      .bind(@, results, fn, key)
      .debounce(75)
      .tap (fn) -> fn()
      .value()
      @addObserver(depKey, f) for depKey in depKeys
      missingObserver = false
    results.value
  .readOnly()


`export default computedPromise`
