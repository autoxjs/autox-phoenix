`import Ember from 'ember'`
`import _x from '../utils/xdash'`
`import _ from 'lodash/lodash'`
`import {Macros} from 'ember-cpm'`
{difference, sum} = Macros
{A, isBlank, isPresent, Service, Evented, inject, computed, Map} = Ember
{alias, lte} = computed
{computed: {access, apply}} = _x
{tap} = _

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
  isFirstPage: lte "prevPage", 0
  clear: -> tap @, =>
    @routes.clear()

  popRoute: (expectedRoute) -> tap @, =>
    actualRoute = @routes.popObject()
    if expectedRoute isnt actualRoute
      throw new Error "Expected '#{expectedRoute?.routeName}', but got '#{actualRoute?.routeName}'"
  
  pushRoute: (route) -> tap @, =>
    @routes.pushObject route unless @routes.contains(route)

  prevPage: (self) ->
    self.get('ctrl').prevPage()

  nextPage: (self) ->
    self.get('ctrl').nextPage()

  update: ->
    if (route = @get "activeRoute")?
      @trigger "update", route
    else
      throw new Error "No routes are active, wtf are you doing try to push in params"

`export default PaginateParamsService`
