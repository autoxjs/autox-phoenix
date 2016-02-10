`import Ember from 'ember'`
`import UserCustomizeMixin from 'autox/mixins/user-customize'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | user customize'

# Replace this with your real tests.
test 'it works', (assert) ->
  UserCustomizeObject = Ember.Object.extend UserCustomizeMixin
  subject = UserCustomizeObject.create()
  assert.ok subject
