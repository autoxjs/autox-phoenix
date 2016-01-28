`import Ember from 'ember'`
`import AutoRouteMixin from '../../../mixins/auto-route'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | auto route'

# Replace this with your real tests.
test 'it works', (assert) ->
  AutoRouteObject = Ember.Object.extend AutoRouteMixin
  subject = AutoRouteObject.create()
  assert.ok subject
