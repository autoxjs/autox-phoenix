`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
{A, isPresent, Object, String, computed: {alias, sort}} = Ember
{flow, dropRight, partialRight, noop, last, isFunction} = _
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
  childRoute: alias "childRoutes.firstObject"
  childrenRoute: alias "childrenRoutes.firstObject"
  modelRoute: alias "modelRoutes.firstObject"
  collectionRoute: alias "collectionRoutes.firstObject"

  childRoutes: sort "childRoutesRaw", compare specificity
  childrenRoutes: sort "childrenRoutesRaw", compare specificity
  modelRoutes: sort "modelRoutesRaw", compare specificity
  collectionRoutes: sort "collectionRoutesRaw", compare specificity
  init: ->
    @_super arguments...
    @set "modelRoutesRaw", A []
    @set "childRoutesRaw", A []
    @set "childrenRoutesRaw", A []
    @set "collectionRoutesRaw", A []
  childRouteClosestTo: (routeName) ->
    @get "childRoutesRaw"
    .sort compare distanceTo routeName
    .get "firstObject"
  childrenRouteClosestTo: (routeName) ->
    @get "childrenRoutesRaw"
    .sort compare distanceTo routeName
    .get "firstObject"
  modelRouteClosestTo: (routeName) ->
    @get "modelRoutesRaw"
    .sort compare distanceTo routeName
    .get "firstObject"
  collectionRouteClosestTo: (routeName) ->
    @get "collectionRoutesRaw"
    .sort compare distanceTo routeName
    .get "firstObject"
  merge: ({collectionRoute, modelRoute, childRoute, childrenRoute}) ->
    if modelRoute?
      @get("modelRoutesRaw").pushObject modelRoute
    if collectionRoute?
      @get("collectionRoutesRaw").pushObject collectionRoute
    if childRoute?
      @get("childRoutesRaw").pushObject childRoute
    if childrenRoute?
      @get("childrenRoutesRaw").pushObject childrenRoute

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
  @types = ["namespace", "child", "children", "collection", "model", "form", "view"]
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
      when "namespace", "collection", "model", "child", "children" then drop1
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
  @childRoute = (modelName, currentRouteName) ->
    if currentRouteName?
      instance.models[modelName]?.childRouteClosestTo(currentRouteName)
    else  
      instance.models[modelName]?.get("childRoute")
  @childrenRoute = (modelName, currentRouteName) ->
    if currentRouteName?
      instance.models[modelName]?.childrenRouteClosestTo(currentRouteName)
    else
      instance.models[modelName]?.get("childrenRoute")
  @modelRoutes = (modelName) ->
    instance.models[modelName]?.get("modelRoutes")
  @collectionRoutes = (modelName) ->
    instance.models[modelName]?.get("collectionRoutes")
  @childRoutes = (modelName) ->
    instance.models[modelName]?.get("childRoutes")
  @childrenRoutes = (modelName) ->
    instance.models[modelName]?.get("childrenRoutes")

class RouteAST
  currentNamespace = A []

  @startNamespace = (name) ->
    currentNamespace.pushObject name
    RouteData.addRoute currentNamespace.join("."),
      type: "namespace"
  @startChild = (childName, modelName) ->
    currentNamespace.pushObject childName
    routeName = currentNamespace.join "."
    RouteData.addModel modelName,
      childRoute: routeName
    RouteData.addRoute routeName,
      type: "child"
      model: modelName
  @startChildren = (childrenName, modelName) ->
    currentNamespace.pushObject childrenName
    routeName = currentNamespace.join "."
    RouteData.addModel modelName,
      childrenRoute: routeName
    RouteData.addRoute routeName,
      type: "children"
      model: modelName
    RouteData.addRoute routeName + ".index",
      type: "view"
      model: modelName
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
  normalize = (name, opts, f) ->
    switch arguments.length
      when 0 then throw new Error "You must pass in at least a name to declare a route"
      when 1 then [name, {}, noop]
      when 2 
        if isFunction(opts) 
          [name, {}, opts] 
        else 
          [name, opts, noop]
      else [name, opts, f]

  @import = (c) ->
    ctxStack.pushObject c
    new DSL()
  @ctx = -> ctxStack.get("lastObject")
  @run = (f) -> 
    if isFunction(f) then ->
      ctxStack.pushObject(@)
      f.call @
      ctxStack.popObject()

  namespace: (name, f=noop) ->
    RouteAST.startNamespace name
    DSL.ctx().route name, path: "/#{name}", DSL.run f
    RouteAST.end name

  child: (name, opts..., f=noop) ->
    [name, {as: modelName}, f] = normalize arguments...
    modelName ?= name
    RouteAST.startChild name, modelName
    DSL.ctx().route name, path: "/#{name}", DSL.run f
    RouteAST.end name

  children: (name, opts..., f=noop) ->
    [name, {as: modelName}, f] = normalize arguments...
    modelName ?= String.singularize name
    RouteAST.startChildren name, modelName
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
