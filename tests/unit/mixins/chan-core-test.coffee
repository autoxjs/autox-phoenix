`import Ember from 'ember'`
`import ChanCoreMixin from 'autox/mixins/chan-core'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | chan core'

# Replace this with your real tests.
test 'it works', (assert) ->
  ChanCoreObject = Ember.Object.extend ChanCoreMixin
  subject = ChanCoreObject.create()
  assert.ok subject
