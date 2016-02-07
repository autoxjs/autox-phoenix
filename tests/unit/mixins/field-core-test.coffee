`import Ember from 'ember'`
`import FieldCoreMixin from '../../../mixins/field-core'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | field core'

# Replace this with your real tests.
test 'it works', (assert) ->
  FieldCoreObject = Ember.Object.extend FieldCoreMixin
  subject = FieldCoreObject.create()
  assert.ok subject
