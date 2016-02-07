`import Ember from 'ember'`
`import _x from './xdash'`
`import {Macros} from 'ember-cpm'`
`import _ from 'lodash/lodash'`
`import FieldCore from '../mixins/field-core'`
{isPromise, computed: {match, apply, access}} = _x
{Object, computed, isPresent, A, isArray, isBlank, RSVP} = Ember
{alias, empty, or: ifAny} = computed
{conditional, join} = Macros
{noop, isFunction, tap} = _

TextType = /^string&(comment|note|body|description)/
DateType = /(date|moment|datetime)/
Field = Object.extend FieldCore,
  canDisplay: ifAny "canModify", "canOnlyDisplay"
  isBasic: empty "choices"
  among: alias "meta.options.among"
  defaultValue: alias "meta.options.defaultValue"  
  typeName: join "type", "name", "&"
  prefix: match "typeName",
    ["string&email", -> "fa-at"],
    [TextType, -> "fa-comment-o"],
    [/^string&password/, -> "fa-lock"],
    [/^string/, -> "fa-pencil"],
    [/money$/, -> "fa-money"],
    [DateType, -> "fa-calendar"],
    [/phone$/, -> "fa-mobile-phone"]
    [_, noop]
  componentName: match "typeName",
    [/^number/, -> "em-number-field"],
    ["string&email", -> "em-email-field"],
    [/^string&password/, -> "em-password-field"],
    [/^string&timezone/, -> "em-timezone-field"],
    [TextType, -> "em-textarea-field"],
    [DateType, -> "em-datetime-field"],
    [/^string/, -> "em-text-field"],
    [_, noop]
  selectChoice: conditional "userChose", "userSelectChoice", "autoxSelectChoice"
  userChose: apply "lookup", "userSelectChoice", (lookup, name) -> isPresent lookup.component(name)
  autoxSelectChoice: "autox-select-choice"
  userSelectChoice: apply "type", (type) -> "#{type}-select-choice"
  presenter: alias "meta.options.presenter"
  proxyKey: apply "meta.options.proxyKey", (key) -> key ? "id"

  preload: (router, store, model) ->
    RSVP.hash
      defaults: @preloadDefaults(router, store, model)
      choices: @preloadChoices(router, store, model)
    .then => @
  preloadDefaults: (router, store, model) ->
    defaultValue = @get "defaultValue"
    name = @get "name"
    notRelationship = not @get "isRelationship"
    if (@get("action") isnt "new") or isBlank(defaultValue) or notRelationship
      return RSVP.resolve(@)
    if isFunction(defaultValue)
      defaultValue = defaultValue(router, store, model)
    if isPromise(defaultValue)
      defaultValue
      .then (value) =>
        model.set name, value
    else
      model.set name, defaultValue
      RSVP.resolve(@)
  preloadChoices: (router, store, model) ->
    among = @get "among"
    cantModify = not @get("canModify")
    if cantModify or isBlank(among) or (@get("action") in ["show", "index"])
      return RSVP.resolve(@)
    if isFunction(among)
      among = among(router, store, model)
    if isPromise(among)
      return among.then (choices) => 
        choices
      .then (choices) =>
        @set "choices", choices
    if isArray(among)
      @set "choices", among
    RSVP.resolve(@)

`export default Field`    