`import Ember from 'ember'`
{isBlank, RSVP, computed, run: {debounce}} = Ember
resolution = (results, fn, key) ->
  if isBlank results.promise
    results.promise = (promise = RSVP.resolve fn.call @)
    promise.then (value) =>
      results.value = value
      delete results.promise
      @notifyPropertyChange key

computedPromise = (depKey, fn) ->
  missingObserver = true
  results = {}
  c = computed depKey, (key) ->
    if missingObserver
      resolution.call(@, results, fn, key)
      @addObserver depKey, @, ->
        debounce(@, resolution, results, fn, key, 75)
      missingObserver = false
    results.value
  c.readOnly()


`export default computedPromise`
