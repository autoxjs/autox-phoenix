`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
{A, isPresent, Object, String, computed: {alias, sort}} = Ember
{flow, dropRight, partialRight, noop, last} = _
split = (sep) -> (str) -> str.split(sep)
join = (sep) -> (arr) -> arr.join(sep)
drop2 = flow split("."), partialRight(dropRight, 2), join(".")
drop1 = flow split("."), partialRight(dropRight, 1), join(".")

compare = (f) -> (a,b) -> f(a) - f(b)
specificity = (str) -> str.split(".").length
distanceTo = (destination) -> 
  destinations = destination?.split(".") ? []
  (origin) ->
    origins = origin?.split(".") ? []
    i = 0
    i++ while i < destinations.length and origins[i] is destinations[i]
    destinations.length - i

ModelData = Object.extend
  modelRoute: alias "modelRoutes.firstObject"
  collectionRoute: alias "collectionRoutes.firstObject"
  modelRoutes: sort "modelRoutesRaw", compare specificity
  collectionRoutes: sort "collectionRoutesRaw", compare specificity
  init: ->
    @_super arguments...
    @set "collectionRoutesRaw", A []
    @set "modelRoutesRaw", A []
  modelRouteClosestTo: (routeName) ->
    @get "modelRoutesRaw"
    .sort compare distanceTo routeName
    .get "firstObject"
  collectionRouteClosestTo: (routeName) ->
    @get "collectionRoutesRaw"
    .sort compare distanceTo routeName
    .get "firstObject"
  merge: ({collectionRoute, modelRoute}) ->
    if modelRoute?
      @get("modelRoutesRaw").pushObject modelRoute
    if collectionRoute?
      @get("collectionRoutesRaw").pushObject collectionRoute

class RouteData
  constructor: ->
    @routes = {}
    @models = {}
  instance = new RouteData()
  @instance = -> instance
  @reset = -> instance = new RouteData()
  @addRoute = (name, routeData) ->
    instance.routes[name] = routeData
  @addModel = (name, routeData) ->
    instance.models[name] ?= ModelData.create {name}
    instance.models[name].merge routeData
  @types = ["namespace", "collection", "model", "form", "view"]
  @routeModel = (routeName) ->
    instance.routes[routeName]?.model
  @routeType = (routeName) ->
    instance.routes[routeName]?.type
  @routeAction = (routeName) ->
    prefix = RouteData.routeType drop1 routeName
    suffix = switch (type = RouteData.routeType routeName)
      when "form", "view" then last split(".") routeName
      else type
    A [prefix, suffix]
    .filter isPresent
    .join "#"
  @parentNodeRoute = (routeName) ->
    f = switch RouteData.routeType(routeName)
      when "form", "view" then drop2
      when "namespace", "collection", "model" then drop1
      else noop
    f routeName

  @modelRoute = (modelName, currentRouteName) ->
    if currentRouteName?
      instance.models[modelName]?.modelRouteClosestTo(currentRouteName)
    else  
      instance.models[modelName]?.get("modelRoute")
  @collectionRoute = (modelName, currentRouteName) ->
    if currentRouteName?
      instance.models[modelName]?.collectionRouteClosestTo(currentRouteName)
    else
      instance.models[modelName]?.get("collectionRoute")
  @modelRoutes = (modelName) ->
    instance.models[modelName]?.get("modelRoutes")
  @collectionRoutes = (modelName) ->
    instance.models[modelName]?.get("collectionRoutes")

class RouteAST
  currentNamespace = A []

  @startNamespace = (name) ->
    currentNamespace.pushObject name
    RouteData.addRoute currentNamespace.join("."),
      type: "namespace"

  @startCollection = (colName) ->
    currentNamespace.pushObject colName
    modelName = String.singularize colName
    routeName = currentNamespace.join(".")
    RouteData.addModel modelName,
      collectionRoute: routeName
    RouteData.addRoute routeName + ".index",
      type: "view"
      model: modelName
    RouteData.addRoute routeName,
      type: "collection"
      model: modelName
  @startModel = (modelName) ->
    currentNamespace.pushObject modelName
    routeName = currentNamespace.join(".")
    RouteData.addModel modelName,
      modelRoute: routeName
    RouteData.addRoute routeName + ".index",
      type: "view"
      model: modelName
    RouteData.addRoute routeName,
      type: "model"
      model: modelName
  @startForm = (name) ->
    parentRoute = currentNamespace.join(".")
    modelName = RouteData.routeModel parentRoute
    currentNamespace.pushObject name
    routeName = currentNamespace.join(".")
    RouteData.addRoute routeName,
      type: "form"
      model: modelName
  @startView = (name) ->
    parentRoute = currentNamespace.join(".")
    modelName = RouteData.routeModel parentRoute
    currentNamespace.pushObject name
    routeName = currentNamespace.join(".")
    RouteData.addRoute routeName,
      type: "view"
      model: modelName
  @end = (name) ->
    x = currentNamespace.popObject()
    throw "Expected '#{name}' but got '#{x}'" if x isnt name

class DSL
  ctxStack = A []
  @import = (c) ->
    ctxStack.pushObject c
    new DSL()
  @ctx = -> ctxStack.get("lastObject")
  @run = (f) -> if f? then ->
    ctxStack.pushObject(@)
    f.call @
    ctxStack.popObject()
  namespace: (name, f=noop) ->
    RouteAST.startNamespace name
    DSL.ctx().route name, path: "/#{name}", DSL.run f
    RouteAST.end name

  collection: (name, f=noop) ->
    RouteAST.startCollection name
    DSL.ctx().route name, path: "/#{name}", DSL.run f
    RouteAST.end name

  model: (name, f=noop) ->
    RouteAST.startModel name
    DSL.ctx().route name, path: "/#{name}/:#{name}_id", DSL.run f
    RouteAST.end name

  form: (name) ->
    RouteAST.startForm name
    DSL.ctx().route name
    RouteAST.end name

  view: (name) ->
    RouteAST.startView name
    DSL.ctx().route name
    RouteAST.end name

`export {RouteData, RouteAST, DSL}`
