`import Ember from 'ember'`
`import ParanoiaMixin from '../../../mixins/paranoia'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | paranoia'

# Replace this with your real tests.
test 'it works', (assert) ->
  ParanoiaObject = Ember.Object.extend ParanoiaMixin
  subject = ParanoiaObject.create()
  assert.ok subject
