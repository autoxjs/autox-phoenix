`import { moduleFor, test } from 'ember-qunit'`

moduleFor 'service:session', 'Unit | Service | session', {
  # Specify the other units that are required for this test.
  needs: ['service:socket', 'model:session', 'model:owner', 'model:user']
}

# Replace this with your real tests.
test 'it exists and works', (assert) ->
  service = @subject()
  assert.ok service
  assert.equal typeof service.instanceInit, "function"
