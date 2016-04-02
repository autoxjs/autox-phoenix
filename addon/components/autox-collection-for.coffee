`import Ember from 'ember'`
`import layout from '../templates/components/autox-collection-for'`
`import {_computed} from '../utils/xdash'`

{computed, inject, isPresent} = Ember
{apply} = _computed
{alias} = computed

AutoxCollectionForComponent = Ember.Component.extend
  layout: layout
  classNames: ["autox-collection-for"]
  classNameBindings: ["userHasDefinedComponent::list-group"]
  lookup: inject.service "lookup"
  fields: alias "meta.fields"
  modelPath: alias "meta.modelPath"
  userDefinedSummaryComponent: apply "collection.firstObject.constructor.modelName", (name) ->
    "summarize-for-#{name}" if isPresent name 
  userHasDefinedSummaryComponent: apply "userDefinedSummaryComponent", "lookup", (c, lookup) ->
    c? and isPresent lookup.component c
  userHasDefinedComponent: apply "userDefinedComponent", "lookup", (c, lookup) ->
    c? and isPresent lookup.component c
  userDefinedComponent: apply "collection.firstObject.constructor.modelName", (name) ->
    "collection-for-#{name}" if isPresent name

`export default AutoxCollectionForComponent`
