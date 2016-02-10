`import Ember from 'ember'`

Route = Ember.Route.extend
  model: ->
    @modelFor "shops.shop"
    .get "histories"
    .reload()
`export default Route`