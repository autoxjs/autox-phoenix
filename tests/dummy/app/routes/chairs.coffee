`import Ember from 'ember'`

{Route, inject} = Ember

ChairsRoute = Route.extend
  model: ->
    @store.findAll "chair"

`export default ChairsRoute`

