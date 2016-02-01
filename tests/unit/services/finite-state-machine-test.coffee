`import { moduleFor, test } from 'ember-qunit'`

moduleFor 'service:finite-state-machine', 'Unit | Service | finite state machine', {
  # Specify the other units that are required for this test.
  # needs: ['service:foo']
}

# Replace this with your real tests.
test 'it exists', (assert) ->
  service = @subject()
  assert.ok service
