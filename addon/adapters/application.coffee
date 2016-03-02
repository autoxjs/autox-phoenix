`import DS from 'ember-data'`
`import CookieCred from '../mixins/cookie-credentials'`

isModel = (x) ->
  typeof x is "object" and
  typeof x.get is "function" and
  typeof x.constructor.modelName is "string"

ApplicationAdapter = DS.JSONAPIAdapter.extend CookieCred,
  urlForQuery: (query, modelName) ->
    {belongsTo} = query
    if isModel(belongsTo)
      parentName = belongsTo.constructor.modelName
      parentId = belongsTo.get("id")
      delete query.belongsTo
      @_buildURL(parentName, parentId) + "/" + @pathForType(modelName)
    else
      @_super arguments...
`export default ApplicationAdapter`
