`import Ember from 'ember'`

Route = Ember.Route.extend
  model: -> @store.findAll "shop"

`export default Route`