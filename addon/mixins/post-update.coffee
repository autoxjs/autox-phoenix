`import Ember from 'ember'`
  
PostUpdate = Ember.Mixin.create
  updateRecord: (store, type, snapshot) ->
    data = {}
    serializer = store.serializerFor(type.modelName)

    serializer.serializeIntoHash(data, type, snapshot, includeId: true)

    id = snapshot.id
    url = @buildURL(type.modelName, id, snapshot, 'updateRecord')

    @ajax(url, 'POST', {data})

`export default PostUpdate`