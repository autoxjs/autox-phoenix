`import Ember from 'ember'`

{Mixin, computed} = Ember
CookieCredentials = Mixin.create
  headers: computed "session.cookie", "cookieKey", 
    get: ->
      key = @get "cookieKey"
      headers = {}
      @session.get "id"
      cookie = @session.get "cookie"
      headers[key] = cookie if key? and cookie?
      headers
      
`export default CookieCredentials`