`import Ember from 'ember'`
`import _ from 'lodash/lodash'`
`import _x from '../utils/xdash'`
{update, tapLog} = _x
{isEmpty, isBlank, isPresent, String, A} = Ember
{zip, isEqual, identity, chain, flow, negate, tap, every, partialRight} = _

invoke = (obj, method, args...) ->
  Ember.assert "Expected '#{method}' on '#{obj?.constructor}' to a function", typeof obj?[method] is "function"
  obj[method].apply obj, args
stringify = (object) ->
  return "null" unless object?
  return object if typeof object in ["number", "string"]
  switch
    when object instanceof Date then moment(object).toISOString()
    when object instanceof moment then object.toISOString()
    when typeof object?.toISOString is "function" then object.toISOString()
    else throw new Query.CantStringifyError object


filterFunctify = (op) ->
  switch op
    when "==" then isEqual
    when "!=" then negate isEqual
    when ">" then (a,b) -> a > b
    when "!>" then (a,b) -> not a > b
    when "<" then (a,b) -> a < b
    when "!<" then (a,b) -> not a < b
    when ">=" then (a,b) -> a >= b
    when "<=" then (a,b) -> a <= b
    when "like" then (a,b) -> a.match new Regex b
    when "ilike" then (a,b) -> a.match new Regex b, "i"
    else -> true

standarization = (op) ->
  switch op.toLowerCase()
    when "is", "=", "==", "===" then "=="
    when "isnt", "not", "!=" then "!="
    when ">", "gt" then ">"
    when "!>", "ngt" then "!>"
    when "<", "lt" then "<"
    when "!<", "nlt" then "!<"
    when ">=", "gte" then ">="
    when "<=", "lte" then "<="
    when "~", "like" then "like"
    when "i~", "ilike" then "ilike"
    else throw new Error "unrecognized operator '#{op}'"

push2 = (obj, field, value) ->
  update obj, field, A([value]), partialRight(tap, (xs) -> xs.pushObject value)

allPresent = partialRight(every, isPresent)

parseFilters = ({filterField, filterOp, filterValue}) ->
  return [] if isBlank(filterField) or isBlank(filterOp) or isBlank(filterValue)
  fields = filterField.split(",")
  ops = filterOp.split(",")
  values = filterValue.split(",")
  zip fields, ops, values
  .filter allPresent

parseSorter = ({sortField, sortDir}) ->
  return [] if isBlank(sortField) or isBlank(sortDir)
  fields = sortField.split(",")
  dirs = sortDir.split(",")
  zip fields, dirs
  .filter allPresent

class Query
  @parse = (queryParams={}) ->
    {pageOffset, pageLimit} = queryParams
    tap new Query(queryParams), (q) ->
      if pageOffset? and pageLimit?
        q.pageBy offset: pageOffset, limit: pageLimit
      for [field, op, value] in parseFilters(queryParams)
        q.filterBy field, op, value
      for [field, dir] in parseSorter(queryParams)
        q.orderBy field, dir
  constructor: (@localParams) ->
    @filters = {}
    @filterFuns = A []
    @pages = {}
    @sorts = A []
    @sortFun = identity
  pageBy: ({offset, limit}) ->
    @pages.offset = offset if offset?
    @pages.limit = limit if limit?
    @
  filterBy: (field, op, value) ->
    chain op
    .thru standarization
    .tap (op) => 
      push2 @filters, String.underscore(field), "#{op}#{stringify value}"
    .tap (op) =>
      newFilter = flow partialRight(Ember.get, field), partialRight(filterFunctify(op), value)
      @filterFuns.pushObject newFilter
    .thru => @
    .value()
  orderBy: (field, dir="asc") ->
    x = switch dir
      when "asc", "+", "ascending", "ASC" then ""
      when "desc", "-", "descending", "DESC" then "-"
      else throw new Error "unknown sort direction '#{dir}'"

    @sortFun = if x is "-"
      (xs) -> xs.sortBy(field).reverse()
    else
      (xs) -> xs.sortBy(field)
    
    @sorts.pushObject x + String.underscore(field)
    @

  considerSorting: (data) ->
    return data if isEmpty @sorts
    data.sort = @sorts

  considerFiltering: (data) ->
    return data if isEmpty @filters
    data.filter = @filters

  considerPagination: (data) ->
    return data if isEmpty @pages
    data.page = @pages
  makeFilterFun: ->
    if isEmpty(fs = @filterFuns)
      -> true
    else
      (x) -> every fs, (f) -> f x
      
  toFunction: ->
    flow @sortFun,
      partialRight(invoke, "filter", @makeFilterFun()), 
      partialRight(invoke, "slice", 0, @pages.limit)
  toParams: ->
    tap {}, (data) =>
      @considerSorting(data)
      @considerFiltering(data)
      @considerPagination(data)

class Query.CantStringifyError extends Error
  message: "unable to stringify"

`export default Query`

