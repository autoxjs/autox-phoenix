`import Ember from 'ember'`

Route = Ember.Route.extend
  model: ->
    @parentNodeModel()
    .get "histories"
    .reload()
`export default Route`