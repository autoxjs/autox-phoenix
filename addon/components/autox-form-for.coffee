`import Ember from 'ember'`
`import layout from '../templates/components/autox-form-for'`
`import {_computed} from '../utils/xdash'`

{computed, inject} = Ember
{apply} = _computed
{alias} = computed
AutoxFormForComponent = Ember.Component.extend
  layout: layout
  classNames: ["autox-form-for"]
  workflow: inject.service "workflow"
  ctx: apply "workflow", "model", (wf, model) -> wf.fetchCtx(model)
  formFields: alias "ctx.fields"

`export default AutoxFormForComponent`
