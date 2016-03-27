`import Ember from 'ember'`

PaginationParamsCore = 
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

PaginationParamsMixin = Ember.Mixin.create(queryParams: PaginationParamsCore)

`export default PaginationParamsMixin`
`export {PaginationParamsMixin, PaginationParamsCore}`