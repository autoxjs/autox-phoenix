`import Ember from 'ember'`
`import StateCore from '../mixins/state-core'`
`import _ from 'lodash/lodash'`

{RSVP, isBlank} = Ember
{isFunction} = _

FieldState = Ember.ObjectProxy.extend StateCore,
  preload: ->
    RSVP.hash
      defaults: @preloadDefaults()
      choices: @preloadChoices()
    .then => @
  preloadDefaults: ->
    model = @get("model")
    defaultValue = @get "defaultValue"
    name = @get "name"
    notRelationship = not @get "isRelationship"
    if (@get("routeAction") isnt "collection#new") or isBlank(defaultValue) or notRelationship
      return RSVP.resolve(@)
    if isFunction(defaultValue)
      defaultValue = defaultValue.call model
    RSVP.resolve defaultValue
    .then (value) -> model.set name, value

  preloadChoices: ->
    among = @get "among"
    model = @get "model"
    cantModify = not @get("canModify")
    if cantModify or isBlank(among) or (@get("routeAction") in ["model#index", "collection#index"])
      return RSVP.resolve(@)
    if isFunction(among)
      among = among.call model
    RSVP.resolve among
    .then (choices) =>
      @set "choices", choices

`export default FieldState`