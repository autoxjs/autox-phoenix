`import Ember from 'ember'`
`import DS from 'ember-data'`

{isBlank} = Ember

Relationship = DS.Model.extend
  relatedParentName: DS.attr "string", virtual: true
  relatedParentId: DS.attr "string", virtual: true
  relatedChildPath: DS.attr "string", virtual: true
  relatedChildType: DS.attr "string", virtual: true
  relatedChildId: DS.attr "string", virtual: true

  relatedParent: computed set: (key, parent) ->
    @set "relatedParentName", parent.get("modelName")
    @set "relatedParentId", parent.get("id")
    parent

  relatedChildMeta: computed set: (key, meta) ->
    {key, kind, type} = meta
    @set "relatedChildPath", key
    @set "relatedChildType", type
    meta
      

`export default Relationship`
