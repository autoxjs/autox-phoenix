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
  workflow: inject.service "workflow"
  lookup: inject.service "lookup"
  ctx: apply "workflow", "collection", (wf, collection) -> wf.fetchCtx(collection)
  fields: alias "ctx.fields"
  modelPath: alias "ctx.modelPath"
  userHasDefinedComponent: apply "userDefinedComponent", "lookup", (c, lookup) ->
    c? and isPresent lookup.component c
  userDefinedComponent: apply "collection.firstObject.constructor.modelName", (name) ->
    "collection-for-#{name}" if isPresent name

`export default AutoxCollectionForComponent`
