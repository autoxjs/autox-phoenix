`import Ember from 'ember'`
`import layout from '../templates/components/autox-form-for'`
`import {_computed} from '../utils/xdash'`

{computed, inject} = Ember
{apply} = _computed
{alias} = computed
AutoxFormForComponent = Ember.Component.extend
  layout: layout
  classNames: ["autox-form-for"]
  formFields: alias "meta.fields"

  actions:
    submit: (model) ->
      @sendAction "action", model

`export default AutoxFormForComponent`
