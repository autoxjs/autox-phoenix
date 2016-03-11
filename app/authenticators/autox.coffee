`import Devise from 'ember-simple-auth/authenticators/devise'`
`import Ember from 'ember'`
`import _x from 'autox/utils/xdash'`
`import _ from 'lodash/lodash'`

{flow, partial, cloneDeep, partial, chain, set} = _
{inject, run, $, RSVP, isBlank} = Ember
{Promise} = RSVP
{tapLog, computed: {apply}} = _x
splitXHR = ({responseJSON, responseText}) -> responseJSON or responseText

Autox = Devise.extend
  store: inject.service("store")
  xession: inject.service("autox-session-context")
  adapter: apply "store", (store) -> store.adapterFor "session"

  restore: (authData={}) ->
    {id, type} = authData.data ? {}
    return RSVP.reject() if isBlank(id) or isBlank(type)
    output = cloneDeep authData
    store = @get("store")
    store.push store.normalize("session", authData.data)
    RSVP.resolve(output)
    
  authenticate: (session) ->
    new Promise (resolve, reject) =>      
      session
      .save()
      .then (session) =>
        chain session.serialize(includeId: true)
        .merge cookie: @get("xession.cookie")
        .thru partial(run, null, resolve)
        .value()
      .catch partial(run, null, reject)

`export default Autox`