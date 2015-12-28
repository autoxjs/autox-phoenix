`import Ember from 'ember'`
`import DS from 'ember-data'`

RelationshipSerializer = DS.JSONAPISerializer.extend
  serialize: (snapshot, options) ->
    data =
      id: snapshot.attr("relatedChildId")
      type: @payloadKeyFromModelName snapshot.attr("relatedChildModelName")
    attributes = snapshot.attr("relatedAttributes")
    attributes.eachAttribute (key, meta) =>
      @serializeAttribute attributes, data, key, meta
    {data}

  serializeAttribute: (snapshot, json, key, meta) ->
    type = meta.type
    json.attributes ?= {}
    value = snapshot.attr(key)
    value = transform.serialize(value) if (transform = @transformFor type)?
    payloadKey = @keyForAttribute(key, "serialize")
    json.attributes[payloadKey] = value

`export default RelationshipSerializer`