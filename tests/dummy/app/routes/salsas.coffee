`import Ember from 'ember'`
`import {PaginationParamsCore} from 'autox/mixins/pagination-params'`
{Route} = Ember

SalsasRoute = Route.extend
  queryParams: PaginationParamsCore

`export default SalsasRoute`

