`import Ember from 'ember'`
`import AttributeField from '../foundations/attribute-field'`
`import ActionField from '../foundations/action-field'`
`import RelationField from '../foundations/relation-field'`
`import _ from 'lodash/lodash'`
{A, Object, computed, isPresent, isArray, inject, String} = Ember
{chain, tap, partial, merge, partialRight, invoke} = _

reEx = (baseClass, core) ->
  extClass = baseClass.extend(core)
  extClass.reopenClass
    fieldName: core.name
  extClass

aboutMeDefault = (factory) ->
  label: "#{factory.modelName} id"
  description: "#{factory.modelName} objects are resourceful representations of data"
  display: ["show", "index"]

getIdField = (factory, fields) ->
  aboutMe = merge aboutMeDefault(factory), factory.aboutMe
  meta =
    type: "string"
    options: aboutMe
  fields.pushObject reEx(AttributeField, {meta, name: "id"})

getAttributeFields = (factory, fields) ->
  factory.eachAttribute (name, meta) ->
    fields.pushObject reEx(AttributeField, {name, meta})

getRelationshipFields = (factory, fields) ->
  factory.eachRelationship (name, meta) ->
    fields.pushObject reEx(RelationField, {name, meta})

getVirtualFields = (factory, fields) ->
  factory.eachVirtualAttribute? (name, meta) ->
    fields.pushObject reEx(AttributeField, {name, meta})

getActionFields = (factory, fields) ->
  factory.eachActionAttribute? (name, meta) ->
    fields.pushObject reEx(ActionField, {name, meta})

getFields = (factory) ->
  chain A()
  .tap partial getIdField, factory
  .tap partial getAttributeFields, factory
  .tap partial getRelationshipFields, factory
  .tap partial getVirtualFields, factory
  .tap partial getActionFields, factory
  .value()

getFieldCollection = (factory) ->
  FieldCollection = Object.extend
    lookup: inject.service "lookup"
    priorityAsc: ["priority:asc"]
    sortedFields: computed.sort "fields", "priorityAsc"
    fields: computed "constructor.modelName", "constructor.fieldClasses", "lookup", ->
      lookup = @get "lookup"
      Ember.assert "has lookup service", isPresent lookup
      modelName = @constructor.modelName
      Ember.assert "has model name", isPresent(modelName)
      nameBase = "field:#{modelName}"
      chain @constructor.fieldClasses
      .tap (classes) -> Ember.assert "has field classes", isArray(classes)
      .tap (classes) -> Ember.assert "no shitty blank fields", classes.every isPresent
      .map (field) -> 
        chain(field.fieldName)
        .tap (name) -> Ember.assert "name should be present", isPresent name
        .value()
      .map (fieldName) -> nameBase + "/" + fieldName
      .map lookup.other.bind(lookup)
      .tap (fields) -> Ember.assert "should be a proper array", isArray(fields)
      .tap (fields) -> Ember.assert "all fields are registered", fields.every(isPresent)
      .value()

  FieldCollection.reopenClass
    modelName: factory.modelName
    fieldClasses: getFields(factory)
  
  FieldCollection

`export {getFields, getFieldCollection, getActionFields, getVirtualFields, getAttributeFields, getIdField, aboutMeDefault}`