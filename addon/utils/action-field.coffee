`import Ember from 'ember'`
`import FieldCore from '../mixins/field-core'`
`import _ from 'lodash/lodash'`
{identity} = _
{RSVP, Object, computed: {oneWay, alias}} = Ember

ActionField = Object.extend FieldCore,
  bubbles: alias "meta.options.bubbles"
  confirm: alias "meta.options.confirm"
  presenter: alias "meta.options.presenter"
  setup: alias "meta.options.setup"
  canDisplay: oneWay "canOnlyDisplay"
  getWhen: -> @get("meta.options")?.when
  setupArgs: (model) ->
    @getWithDefault "setup", identity
    .call model, @get("ctx")
  performAction: (model, args) ->
    model.get @get "name"
    .call model, args
  invokeAction: (model) ->
    RSVP.resolve @setupArgs(model)
    .then (args) => @performAction(model, args)

`export default ActionField`
