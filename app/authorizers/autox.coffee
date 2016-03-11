`import Devise from 'ember-simple-auth/authorizers/devise'`
`import Ember from 'ember'`
`import ENV from '../config/environment'`

{inject, get, isPresent} = Ember

Authorizer = Devise.extend
  xession: inject.service("autox-session-context")

  authorize: (data, block) ->
    xession = @get "xession"
    if xession.get("loggedIn") and isPresent(data?.cookie)
      authStr = data.cookie
      block(ENV.cookieKey, authStr)

`export default Authorizer`