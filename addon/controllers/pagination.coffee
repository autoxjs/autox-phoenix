`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
`import Query from '../utils/query'`
{chain, tap, pick} = _
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

  cast: (params) ->
    for key, value of params when value? and key in PaginateFields
      @set key, value 

  activeQuery: Ember.computed PaginateFields..., ->
    Query.parse objectify @, PaginateFields

  nextPage: ->
    @incrementProperty "pageOffset", parseInt @getWithDefault("pageLimit", 0)

  prevPage: ->
    return if @getWithDefault("pageOffset", 0) <= 0
    @decrementProperty "pageOffset", parseInt @getWithDefault("pageLimit", 0)

PaginationController = Ember.Controller.extend PaginateControlsCore

`export {PaginationController, PaginateControlsCore}`
`export default PaginationController`