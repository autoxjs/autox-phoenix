`import Ember from 'ember'`
`import SessionStateMixin from 'autox/mixins/session-state'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | session state'

# Replace this with your real tests.
test 'it works', (assert) ->
  SessionStateObject = Ember.Object.extend SessionStateMixin
  subject = SessionStateObject.create()
  assert.ok subject
