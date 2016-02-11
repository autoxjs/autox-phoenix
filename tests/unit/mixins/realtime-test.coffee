`import Ember from 'ember'`
`import RealtimeMixin from '../../../mixins/realtime'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | realtime'

# Replace this with your real tests.
test 'it works', (assert) ->
  RealtimeObject = Ember.Object.extend RealtimeMixin
  subject = RealtimeObject.create()
  assert.ok subject
