`import DS from 'ember-data'`
`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
{isFunction} = _
{get, RSVP, getWithDefault, isPresent, isBlank, isArray, A} = Ember
HistoricalMixin = Ember.Mixin.create
  histories: DS.hasMany "history", async: true
  latestHistoryHas: (attr, tester) ->
    f = switch
      when isBlank tester then isPresent
      when isFunction tester then tester
      when isArray tester then (x) -> A(tester).contains x
      else 
        (x) -> 
          x is tester
    @latestHistory()
    .then (history) ->
      isFunction(history?.get) and f(history.get attr)

  latestHistory: ->
    @get "histories"
    .then (histories) ->
      get(histories, "firstObject")
  latestMentioned: ->
    @latestHistory()
    .then (history) ->
      history?.mentionedModel()

`export default HistoricalMixin`