`import DS from 'ember-data'`

RelationshipAdapter = DS.JSONAPIAdapter.extend
  urlForCreateRecord: (modelName, snapshot) ->
    base = @_buildURL(snapshot.attr("relatedParentName"), snapshot.attr("relatedParentId"))
    base + "/relationships/" + snapshot.attr("relatedChildPath")
    
  updateRecord: (store, type, snapshot) ->
    throw new Error "Update Not Suppported!"

  urlForDeleteRecord: (id, modelName, snapshot) ->
    @urlForCreateRecord(modelName, snapshot)

`export default RelationshipAdapter`
