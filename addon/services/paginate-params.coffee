`import Ember from 'ember'`
`import _x from '../utils/xdash'`
`import _ from 'lodash/lodash'`

{A, isBlank, isPresent, Service, Evented, inject, computed, Map, getWithDefault} = Ember
{alias, filter, lte} = computed
{tapLog, computed: {access, apply}} = _x
{tap, partialRight, flow, endsWith} = _

sum = (a, b) ->
  computed a, b, ->
    x = parseFloat @getWithDefault(a, 0)
    y = parseFloat @getWithDefault(b, 0)
    x + y

difference = (a, b) ->
  computed a, b, ->
    x = parseFloat @getWithDefault(a, 0)
    y = parseFloat @getWithDefault(b, 0)
    if (z = x - y) <= 0 then 0 else z

isCollection = (route) ->
  action = route.getWithDefault("routeAction", "")
  endsWith action, "collection"

PaginateParamsService = Service.extend Evented,
  lookup: inject.service("lookup")
  ctrl: apply "lookup", (lookup) -> lookup.controller "pagination"
  routes: A []
  activeRoute: alias "routes.lastObject"
  activeQuery: alias "ctrl.activeQuery"
  activeParams: alias "activeQuery.localParams"
  activeQueryParams: apply "activeQuery", (q) -> q?.toParams()
  activeQueryFunc: apply "activeQuery", (q) -> q?.toFunction()
  prevPage: difference "ctrl.pageOffset", "ctrl.pageLimit"
  nextPage: sum "ctrl.pageOffset", "ctrl.pageLimit"
  collectionRoutes: filter "routes", isCollection
  deepestCollectionRoute: alias "collectionRoutes.lastObject"
  isFirstPage: lte "prevPage", 0
  clear: -> tap @, =>
    @routes.clear()

  popRoute: (expectedRoute) -> tap @, =>
    actualRoute = @routes.popObject()
    if expectedRoute isnt actualRoute
      throw new Error "Expected '#{expectedRoute?.routeName}', but got '#{actualRoute?.routeName}'"
  
  pushRoute: (route) -> tap @, =>
    @routes.pushObject route unless @routes.contains(route)

  go2PrevPage: (self) ->
    self.get('ctrl').prevPage()

  go2NextPage: (self) ->
    self.get('ctrl').nextPage()

  manualUpdate: (params) ->
    @get "ctrl"
    .cast params

`export default PaginateParamsService`
