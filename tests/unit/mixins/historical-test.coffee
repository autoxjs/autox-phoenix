`import Ember from 'ember'`
`import HistoricalMixin from 'autox/mixins/historical'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | historical'

# Replace this with your real tests.
test 'it works', (assert) ->
  HistoricalObject = Ember.Object.extend HistoricalMixin
  subject = HistoricalObject.create()
  assert.ok subject
