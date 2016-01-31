`import Ember from 'ember'`
`import layout from '../templates/components/autox-show-for'`
`import {_computed} from '../utils/xdash'`

{computed, inject, isPresent} = Ember
{apply} = _computed
{alias} = computed

AutoxShowForComponent = Ember.Component.extend
  layout: layout
  tagName: "ul"
  workflow: inject.service "workflow"
  classNames: ["autox-show-for"]
  classNameBindings: ["userHasDefinedComponent::list-group"]
  ctx: apply "workflow", "model", (wf, model) -> wf.fetchCtx(model)
  fields: alias "ctx.fields"
  userHasDefinedComponent: apply "userDefinedComponent", "lookup", (c, lookup) ->
    c? and isPresent lookup.component c
  userDefinedComponent: apply "model.constructor.modelName", (name) ->
    "model-for-#{name}" if isPresent name

`export default AutoxShowForComponent`
