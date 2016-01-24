`import Ember from 'ember'`
`import layout from '../templates/components/autox-form-for'`
`import Schema from '../utils/schema'`
{computed, inject} = Ember

AutoxFormForComponent = Ember.Component.extend
  layout: layout
  classNames: ["autox-form-for"]
  ctx: inject.service "context"
  formFields: computed "model", "ctx",
    get: ->
      factory = @get "model"
      .constructor
      ctx = @get "ctx"
      action = @get "action"
      Schema.getFields({factory, ctx, action})

`export default AutoxFormForComponent`
