`import Ember from 'ember'`
`import layout from '../templates/components/autox-show-for'`
`import {_computed} from '../utils/xdash'`

{computed, inject} = Ember
{apply} = _computed
{alias} = computed

AutoxShowForComponent = Ember.Component.extend
  layout: layout
  tagName: "ul"
  workflow: inject.service "workflow"
  classNames: ["autox-show-for", "list-group"]
  ctx: apply "workflow", "model", (wf, model) -> wf.fetchCtx(model)
  fields: alias "ctx.fields"

`export default AutoxShowForComponent`
