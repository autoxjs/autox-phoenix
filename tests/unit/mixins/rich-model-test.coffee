`import Ember from 'ember'`
`import RichModelMixin from 'autox/mixins/rich-model'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | rich model'

# Replace this with your real tests.
test 'it works', (assert) ->
  RichModelObject = Ember.Object.extend RichModelMixin
  subject = RichModelObject.create()
  assert.ok subject
