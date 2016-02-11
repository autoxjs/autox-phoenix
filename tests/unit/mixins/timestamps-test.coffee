`import Ember from 'ember'`
`import TimestampsMixin from '../../../mixins/timestamps'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | timestamps'

# Replace this with your real tests.
test 'it works', (assert) ->
  TimestampsObject = Ember.Object.extend TimestampsMixin
  subject = TimestampsObject.create()
  assert.ok subject
