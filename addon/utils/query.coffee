`import Ember from 'ember'`

{isBlank, String, A} = Ember

stringify = (object) ->
  return "null" unless object?
  return object if typeof object in ["number", "string"]
  switch
    when object instanceof Date then moment(object).toISOString()
    when object instanceof moment then object.toISOString()
    when typeof object?.toISOString is "function" then object.toISOString()
    else throw new Query.CantStringifyError object

class Query
  pageBy: ({offset, limit}) ->
    @pages ?= {}
    @pages.offset = offset if offset?
    @pages.limit = limit if limit?
    @
  filterBy: (field, op, value) ->
    op = switch op.toLowerCase()
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
    @filters ?= {}
    @filters[String.underscore(field)] ?= A([])
    value = stringify(value)
    @filters[String.underscore(field)].pushObject("#{op}#{value}")
    @
  orderBy: (field, dir="asc") ->
    x = switch dir
      when "asc", "+", "ascending", "ASC" then ""
      when "desc", "-", "descending", "DESC" then "-"
      else throw new Error "unknown sort direction '#{dir}'"
    @sorts ?= A([])
    @sorts.pushObject x + String.underscore(field)
    @

  considerSorting: (data) ->
    return data if isBlank @sorts
    data.sort = @sorts

  considerFiltering: (data) ->
    return data if isBlank @filters
    data.filter = @filters

  considerPagination: (data) ->
    return data if isBlank @pages
    data.page = @pages
  toParams: ->
    data = {}
    @considerSorting(data)
    @considerFiltering(data)
    @considerPagination(data)
    data

class Query.CantStringifyError extends Error
  message: "unable to stringify"

`export default Query`

