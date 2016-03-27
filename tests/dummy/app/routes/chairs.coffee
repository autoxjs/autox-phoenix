`import Ember from 'ember'`

{Route, inject} = Ember

ChairsRoute = Route.extend
  queryParams:
    pageOffset:
      refreshModel: true
    pageLimit:
      refreshModel: true
    sortField:
      refreshModel: true
    sortDir:
      refreshModel: true
    filterOp:
      refreshModel: true
    filterField:
      refreshModel: true
    filterValue:
      refreshModel: true
  model: ->
    @store.findAll "chair"

`export default ChairsRoute`

