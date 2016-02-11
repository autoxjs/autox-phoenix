`import Ember from 'ember'`
`import layout from '../templates/components/autox-show-action-field'`
`import UserCustomize from '../mixins/user-customize'`
`import _ from 'lodash/lodash'`
`import _x from '../utils/xdash'`
{hasFunctions} = _x
{partialRight} = _
{computed: {and: ifAll, not: cant}} = Ember
isComputed = partialRight hasFunctions, "get", "meta", "readOnly", "property", "volatile"
AutoxShowActionFieldComponent = Ember.Component.extend UserCustomize,
  tagName: "button"
  customPrefix: "show-for-action-field"
  layout: layout
  classNames: ["autox-show-action-field"]
  attributeBindings: ["field.name:aria-label", "disabled"]
  classNameBindings: ["userHasDefinedComponent::list-group-item", "isBusy:disabled:", "canDisplay::hidden"]
  canDisplay: ifAll "field.canOnlyDisplay", "isPermissible"
  disabled: cant "canDisplay"
  isPermissible: true

  didInitAttrs: ->
    @attachPermissible()
    @registerInteraction()

  attachPermissible: ->
    w = @get("field")?.getWhen()
    if isComputed(w) then @isPermissible = w
  willDestroyElement: ->
    @off @get("field.type"), @, @invokeAction
  registerInteraction: ->
    @on @get("field.type"), @, @invokeAction

  invokeAction: (event) ->
    return if @get("isBusy")
    @set "isBusy", true
    (field = @get "field")
    .invokeAction @get("model")
    .then (result) =>
      if field.get("bubbles")
        @sendAction "invoke", field, result
    .finally =>
      @set "isBusy", false

`export default AutoxShowActionFieldComponent`
