`import Devise from 'ember-simple-auth/authorizers/devise'`
`import Ember from 'ember'`

{inject: {service}, get, isPresent} = Ember

Authorizer = Devise.extend
  config: service('config')

  authorize: (data, block) ->
    if isPresent(data?.cookie)
      authStr = data.cookie
      cookieKey = @get("config.cookieKey")
      block(cookieKey, authStr)

`export default Authorizer`
