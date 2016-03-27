`import Ember from 'ember'`
`import {PaginationParamsCore} from 'autox/mixins/pagination-params'`
{Route, computed} = Ember

ShopsRoute = Route.extend
  queryParams: computed "routeName", -> PaginationParamsCore

`export default ShopsRoute`

