`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
`import Query from '../utils/query'`
{chain, tap} = _
{Mixin, inject, observer, get, set} = Ember

objectify = (obj, keys) ->
  chain(keys)
  .map (key) -> [key, get(obj, key)]
  .zipObject()
  .value()

PaginateFields = ["pageOffset", "pageLimit", "sortField", "sortDir", "filterOp", "filterField", "filterValue"]

PaginateControlsCore = 
  paginateParams: inject.service("paginate-params")
  queryParams: PaginateFields
  pageOffset: 0
  pageLimit: 25
  sortDir: "desc"
  sortField: "id"

  activeQuery: Ember.computed PaginateFields..., ->
    Query.parse objectify @, PaginateFields

  queryParamsHasChanged: observer PaginateFields..., ->
    @get("paginateParams").update()

  nextPage: ->
    @incrementProperty "pageOffset", @get("pageLimit")

  prevPage: ->
    return if @getWithDefault("pageOffset", 0) <= 0
    @decrementProperty "pageOffset", @get("pageLimit")

PaginationController = Ember.Controller.extend PaginateControlsCore

`export {PaginationController, PaginateControlsCore}`
`export default PaginationController`