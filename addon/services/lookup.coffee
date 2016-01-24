`import Ember from 'ember'`

LookupService = Ember.Service.extend
  instanceInit: (@app) ->
  component: (name) -> @other "component:#{name}"
  transform: (name) -> @other "transform:#{name}"
  other: (name) -> @app.lookup(name)

`export default LookupService`
