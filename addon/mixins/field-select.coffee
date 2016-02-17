`import Ember from 'ember'`
`import _x from '../utils/xdash'`
`import _ from 'lodash/lodash'`
`import {Macros} from 'ember-cpm'`
{RSVP, isBlank, isPresent, computed: {alias, empty}} = Ember
{computed: {apply}} = _x
{conditional} = Macros
{noop, isFunction, tap} = _
FieldSelectMixin = Ember.Mixin.create
  isBasic: empty "choices"
  among: alias "meta.options.among"
  selectChoice: conditional "userChose", "userSelectChoice", "autoxSelectChoice"
  userChose: apply "lookup", "userSelectChoice", (lookup, name) -> isPresent lookup.component(name)
  autoxSelectChoice: "autox-select-choice"
  userSelectChoice: apply "type", (type) -> "#{type}-select-choice"
  defaultValue: alias "meta.options.defaultValue"

  preload: (router, store, model) ->
    RSVP.hash
      defaults: @preloadDefaults(router, store, model)
      choices: @preloadChoices(router, store, model)
    .then => @
  preloadDefaults: (router, store, model) ->
    defaultValue = @get "defaultValue"
    name = @get "name"
    notRelationship = not @get "isRelationship"
    if (@get("action") isnt "collection#new") or isBlank(defaultValue) or notRelationship
      return RSVP.resolve(@)
    if isFunction(defaultValue)
      defaultValue = defaultValue(router, store, model)
    RSVP.resolve defaultValue
    .then (value) -> model.set name, value

  preloadChoices: (router, store, model) ->
    among = @get "among"
    cantModify = not @get("canModify")
    if cantModify or isBlank(among) or (@get("action") in ["model#index", "collection#index"])
      return RSVP.resolve(@)
    if isFunction(among)
      among = among(router, store, model)
    RSVP.resolve among
    .then (choices) =>
      @set "choices", choices
`export default FieldSelectMixin`
