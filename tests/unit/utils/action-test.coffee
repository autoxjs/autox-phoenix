`import action from 'autox/utils/action'`
`import { module, test } from 'qunit'`
`import Ember from 'ember'`

{K} = Ember
module 'Unit | Utility | action'

# Replace this with your real tests.
test 'it works as intended', (assert) ->
  {f, actionState} = action.needs("dog", "cat:3", "bat:many", K)
  assert.equal typeof f, "function", "is a function"
  assert.ok actionState
  assert.equal actionState.get("needs.length"), 3
  assert.equal actionState.get("activeNeed.modelName"), "dog", "we need dogs"
  assert.equal actionState.get("activeNeed.amount"), 1, "we need at least 1 dog"

test "it works on independent actions", (assert) ->
  {actionState} = action.needs(K)
  assert.equal actionState.get("needs.length"), 0, "we should have no needs"
  assert.equal actionState.get("activeIndex"), 0, "index at 0"
  assert.ok actionState.get("allFulfilled"), "actions without needs should automatically be fulfilled"