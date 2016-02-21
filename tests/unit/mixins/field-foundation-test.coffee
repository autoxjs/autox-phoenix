`import Ember from 'ember'`
`import FieldFoundationMixin from 'autox/mixins/field-foundation'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | field foundation'

# Replace this with your real tests.
test 'it works', (assert) ->
  FieldFoundationObject = Ember.Object.extend FieldFoundationMixin
  subject = FieldFoundationObject.create()
  assert.ok subject
