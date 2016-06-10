`import Devise from 'ember-simple-auth/authenticators/devise'`
`import Ember from 'ember'`
`import _x from 'ember-autox-core/utils/xdash'`
`import _ from 'lodash/lodash'`

{flow, partial, cloneDeep, partial, chain, set} = _
{inject: {service}, computed, run, $, RSVP, isBlank} = Ember
{Promise} = RSVP
{tapLog, computed: {apply}} = _x
splitXHR = ({responseJSON, responseText}) -> responseJSON or responseText

Autox = Devise.extend
  store: service("store")
  adapter: apply "store", (store) -> store.adapterFor "session"

  restore: (authData={}) ->
    {id, type} = authData.data ? {}
    return RSVP.reject() if isBlank(id) or isBlank(type)
    output = cloneDeep authData
    store = @get("store")
    store.push store.normalize("session", authData.data)
    RSVP.resolve(output)

  authenticate: (params) ->
    @castSession params
    .save()
    .then (session) ->
      session.serialize(includeId: true)

  castSession: (params) ->
    {store, model} = @getProperties "store", "model"
    sessionClass = store.modelFor "session"
    sessionClass.eachAttribute (name) ->
      if (value = Ember.get(params, name))?
        model.set name, value
    sessionClass.eachRelatedType (name) ->
      if (value = Ember.get(params, name))?
        model.set name, value
    model

  model: computed "isAuthenticated", ->
    {store, isAuthenticated} = @getProperties "store", "isAuthenticated"
    if isAuthenticated
      store.peekRecord "session", @get("data.authenticated.data.id")
    else
      store.createRecord "session"

`export default Autox`
