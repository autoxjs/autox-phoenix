`import DS from 'ember-data'`

RelationshipSerializer = DS.JSONAPISerializer.extend
  serialize: (snapshot, options) ->
    {data} = @_super arguments...
    data.type = @payloadKeyFromModelName snapshot.attr("relatedChildType")
    data.id = snapshot.attr("relatedChildId") if snapshot.attr("relatedChildId")?
    {data}
  serializeAttribute: (snapshot, json, key, meta) ->
    type = meta.type
    real = not meta.virtual
    if @_canSerialize(key) and real
      json.attributes ?= []

      value = snapshot.attr(key)
      value = @transformFor(type)?(value) if type?
      
      payloadKey = @_getMappedKey(key, snapshot.type)

      if payloadKey is key
        payloadKey = @keyForAttribute(key, "serialize")

      json.attributes[payloadKey] = value

`export default RelationshipSerializer`
