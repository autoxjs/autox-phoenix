`import Ember from 'ember'`

{Route, inject} = Ember

IndexRoute = Route.extend
  session: inject.service("session")

`export default IndexRoute`

