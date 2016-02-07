`import Ember from 'ember'`
`import layout from '../templates/components/autox-show-action-field'`
`import UserCustomize from '../mixins/user-customize'`
`import _ from 'lodash/lodash'`
`import _x from '../utils/xdash'`
{RSVP, String, computed: {and: ifAll}} = Ember
{flow} = _
{computed: {apply}} = _x
AutoxShowActionFieldComponent = Ember.Component.extend UserCustomize,
  customPrefix: "show-for-action-field"
  layout: layout
  classNames: ["autox-show-action-field"]
  classNameBindings: ["userHasDefinedComponent::list-group-item", "isBusy:disabled:", "canDisplay::hidden"]
  canDisplay: ifAll "field.canOnlyDisplay", "isPermissible"
  
  decidePermission: ->
    model = @get "model"
    f = switch typeof (w = @getWithDefault "field.when", -> true)
      when "string" then -> RSVP.resolve @get w
      when "function" then flow(w, RSVP.resolve)
      else -> RSVP.resolve w
    f.call model, @fsm, @
    .then (isPermissible) =>
      if isPermissible
        @set "isPermissible", true
      else
        @sendAction "kill", @get("field")
  didInitAttrs: ->
    @decidePermission()
    @registerInteraction()

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
