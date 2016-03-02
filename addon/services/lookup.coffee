`import Ember from 'ember'`

LookupService = Ember.Service.extend
  instanceInit: (@app) ->
  component: (name) -> @other "component:#{name}"
  transform: (name) -> @other "transform:#{name}"
  template: (name) -> @other "template:#{name}"
  route: (name) -> @other "route:#{name}"
  controller: (name) -> @other "controller:#{name}"
  service: (name) -> @other "service:#{name}"
  other: (name) -> @app.lookup(name)

`export default LookupService`
