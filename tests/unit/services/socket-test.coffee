`import Phoenix from 'ember-phoenix-chan'`
`import ENV from 'dummy/config/environment'`

{Socket} = Phoenix
{socketNamespace} = ENV

`import { moduleFor, test } from 'ember-qunit'`

moduleFor 'service:socket', 'Unit | Service | socket', {
  # Specify the other units that are required for this test.
  needs: ['service:session', 'model:user', 'model:session', 'model:owner']
}

# Replace this with your real tests.
test 'it exists', (assert) ->
  service = @subject()
  assert.ok service
  Ember.run =>
    service.instanceInit(Socket, socketNamespace)
    assert.ok service.get("session")
