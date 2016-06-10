`import Ember from 'ember'`

{Mixin, get, set} = Ember
SessionAdapter = Mixin.create
  handleResponse: (status, header, payload) ->
    key = @get "cookieKey"
    if (cookie = get(header, key))?
      set payload, "data.attributes.cookie", cookie
    @_super status, header, payload

`export default SessionAdapter`
