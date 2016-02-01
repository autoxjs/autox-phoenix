`import Ember from 'ember'`
`import layout from '../templates/components/autox-select-choice'`
`import _x from '../utils/xdash'`
{computed: {alias, oneWay, not: negate, or: ifAny}} = Ember
{isPromise, computed: {apply}} = _x
AutoxSelectChoiceComponent = Ember.Component.extend
  layout: layout
  isObjectType: ifAny "modelValue", "modelName"
  isBasicType: negate "isObjectType"
  modelProxy: apply "model", "proxyKey", (m, p) -> m?.get(p) if p?
  modelValue: ifAny "modelProxy", "modelId"
  modelName: oneWay "model.constructor.modelName"
  proxyKey: alias "field.proxyKey"
  didInsertElement: ->
    if isPromise(m = @get "model")
      Ember.run.later =>
        m.then (model) =>
          pk = @getWithDefault("proxyKey", "id")
          @set "modelValue", model.get(pk)
          @set "modelName", model.constructor.modelName

`export default AutoxSelectChoiceComponent`
