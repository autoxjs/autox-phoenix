`import Ember from 'ember'`
`import layout from '../templates/components/autox-show-for'`
`import {_computed} from '../utils/xdash'`
`import UserCustomize from '../mixins/user-customize'`

{computed, inject, isPresent} = Ember
{apply} = _computed
{alias} = computed

AutoxShowForComponent = Ember.Component.extend UserCustomize,
  customPrefix: "show-for-model"
  layout: layout
  workflow: inject.service "workflow"
  classNames: ["autox-show-for"]
  classNameBindings: ["userHasDefinedComponent::list-group"]
  ctx: apply "workflow", "model", (wf, model) -> wf.fetchCtx(model)
  fields: alias "ctx.fields"

`export default AutoxShowForComponent`
