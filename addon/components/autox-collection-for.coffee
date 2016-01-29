`import Ember from 'ember'`
`import layout from '../templates/components/autox-collection-for'`
`import {_computed} from '../utils/xdash'`

{computed, inject} = Ember
{apply} = _computed
{alias} = computed

AutoxCollectionForComponent = Ember.Component.extend
  layout: layout
  classNames: ["autox-collection-for", "list-group"]
  workflow: inject.service "workflow"
  ctx: apply "workflow", "collection", (wf, collection) -> wf.fetchCtx(collection)
  fields: alias "ctx.fields"
  modelPath: alias "ctx.modelPath"

`export default AutoxCollectionForComponent`
