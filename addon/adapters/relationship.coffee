`import Ember from 'ember'`
`import DS from 'ember-data'`

RelationshipAdapter = DS.JSONAPIAdapter.extend
  ajaxOptions: ->
    hash = @_super arguments...
    hash.xhrFields = 
      withCredentials: true
    hash

  deleteRecord: (store, type, snapshot) ->
    data = {}
    serializer = store.serializerFor(type.modelName)
    serializer.serializeIntoHash(data, type, snapshot)
    url = @buildURL(type.modelName, "_id", snapshot, 'deleteRecord')

    @ajax(url, "DELETE", {data})

  updateRecord: (store, type, snapshot) ->
    throw new Error "Update Not Suppported!"

  urlForCreateRecord: (modelName, snapshot) ->
    base = @_buildURL(snapshot.attr("relatedParentModelName"), snapshot.attr("relatedParentId"))
    base + "/relationships/" + snapshot.attr("relatedChildPath")

  urlForDeleteRecord: (id, modelName, snapshot) ->
    @urlForCreateRecord(modelName, snapshot)

`export default RelationshipAdapter`
