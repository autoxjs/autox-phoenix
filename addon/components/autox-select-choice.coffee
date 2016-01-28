`import Ember from 'ember'`
`import layout from '../templates/components/autox-select-choice'`

{computed: {none, or: ifAny}} = Ember

AutoxSelectChoiceComponent = Ember.Component.extend
  layout: layout
  isObjectType: ifAny "model.id", "model.constructor.modelName"
  isBasicType: none "isObjectType"

`export default AutoxSelectChoiceComponent`
