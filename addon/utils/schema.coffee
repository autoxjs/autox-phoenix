`import Ember from 'ember'`
`import AttributeField from '../models/attribute-field'`
`import ActionField from '../models/action-field'`
`import RelationField from '../models/relation-field'`
`import _ from 'lodash/lodash'`
{A} = Ember
{chain, partial, merge} = _

aboutMeDefault = (factory) ->
  label: "#{factory.modelName} id"
  description: "#{factory.modelName} objects are resourceful representations of data"
  display: ["show", "index"]

getIdField = ({factory, ctx}, fields) ->
  aboutMe = merge aboutMeDefault(factory), factory.aboutMe
  meta =
    type: "string"
    options: aboutMe
  fields.pushObject AttributeField.create {meta, ctx, name: "id"}

getAttributeFields = ({factory, ctx}, fields) ->
  factory.eachAttribute (name, meta) ->
    fields.pushObject AttributeField.create {name, meta, ctx}

getRelationshipFields = ({factory, ctx}, fields) ->
  factory.eachRelationship (name, meta) ->
    fields.pushObject RelationField.create {name, meta, ctx}

getVirtualFields = ({factory, ctx}, fields) ->
  factory.eachVirtualAttribute? (name, meta) ->
    fields.pushObject AttributeField.create {name, meta, ctx}

getActionFields = ({factory, ctx}, fields) ->
  factory.eachActionAttribute? (name, meta) ->
    fields.pushObject ActionField.create {name, meta, ctx}

getFields = (params) ->
  chain A()
  .tap partial getIdField, params
  .tap partial getAttributeFields, params
  .tap partial getRelationshipFields, params
  .tap partial getVirtualFields, params
  .tap partial getActionFields, params
  .thru (fields) -> fields.sortBy "priority"
  .value()

`export {getFields, getActionFields, getVirtualFields, getAttributeFields, getIdField, aboutMeDefault}`