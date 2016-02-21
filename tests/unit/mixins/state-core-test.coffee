`import Ember from 'ember'`
`import StateCoreMixin from 'autox/mixins/state-core'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | state core'

# Replace this with your real tests.
test 'it works', (assert) ->
  StateCoreObject = Ember.Object.extend StateCoreMixin
  subject = StateCoreObject.create()
  assert.ok subject
