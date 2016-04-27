`import Ember from 'ember'`
`import layout from '../templates/components/autox-show-action-field'`
`import UserCustomize from '../mixins/user-customize'`
`import _ from 'lodash/lodash'`
`import _x from '../utils/xdash'`
{hasFunctions} = _x
{partialRight} = _
{isBlank, computed: {alias, and: ifAll, not: cant}} = Ember
isComputed = partialRight hasFunctions, "get", "meta", "readOnly", "property", "volatile"

AutoxActionFieldCore = Ember.Mixin.create
  canDisplay: ifAll "field.canOnlyDisplay", "isPermissible", "notInAnotherAction"
  disabled: cant "canDisplay"
  isPermissible: alias "actionState.when"
  notInAnotherAction: cant "actionState.inAnotherAction"
  actionState: alias "field"

  didInitAttrs: ->
    @registerInteraction()

  willDestroyElement: ->
    throw "No Field Type" if isBlank @get("field.type")
    @off @get("field.type"), @, @invokeAction
  registerInteraction: ->
    throw "No Field Type" if isBlank @get("field.type")
    @on @get("field.type"), @, @invokeAction

  invokeAction: (event) ->
    return if @get("isBusy")
    @set "isBusy", true
    (field = @get "field")
    .invokeAction @get("model")
    .then ({state}) =>
      @sendAction "invoke", field, state
    .finally =>
      @set "isBusy", false

AutoxShowActionFieldComponent = Ember.Component.extend UserCustomize, AutoxActionFieldCore,
  tagName: "button"
  customPrefix: "show-for-action-field"
  layout: layout
  classNames: ["autox-show-action-field"]
  attributeBindings: ["field.name:aria-label", "disabled"]
  classNameBindings: ["userHasDefinedComponent::list-group-item", "isBusy:disabled:", "canDisplay::hidden"]

`export {AutoxActionFieldCore, AutoxShowActionFieldComponent}`
`export default AutoxShowActionFieldComponent`
