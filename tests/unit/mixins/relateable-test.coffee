`import Ember from 'ember'`
`import {RelateableMixin} from 'ember-autox'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | relateable'

# Replace this with your real tests.
test 'it works', (assert) ->
  RelateableObject = Ember.Object.extend RelateableMixin
  subject = RelateableObject.create()
  assert.ok subject
