`import Ember from 'ember'`
`import RelateableMixin from '../../../mixins/relateable'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | relateable'

# Replace this with your real tests.
test 'it works', (assert) ->
  RelateableObject = Ember.Object.extend RelateableMixin
  subject = RelateableObject.create()
  assert.ok subject
