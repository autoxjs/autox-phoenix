`import Ember from 'ember'`

{Mixin, get} = Ember
SessionAdapter = Mixin.create
  handleResponse: (status, header, payload) ->
    key = @get "cookieKey"
    session = @get "session"
    if (cookie = get(header, key))?
      session.set "cookie", cookie
    @_super arguments...

`export default SessionAdapter`