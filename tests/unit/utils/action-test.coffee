`import action from 'autox/utils/action'`
`import { module, test } from 'qunit'`
`import Ember from 'ember'`

{K} = Ember
module 'Unit | Utility | action'

class Dog
  @modelName = "dog"

class Cat
  @modelName = "cat"

class Rat
  @modelName = "rat"

# Replace this with your real tests.
test 'it works as intended', (assert) ->
  assert.ok action.needs
  {f, needCores} = action.needs("dog", "cat:3", "bat:many", K)
  assert.equal typeof f, "function", "is a function"
  assert.ok needCores
  assert.equal needCores.length, 3
  assert.deepEqual needCores, [
    {amount: 1, modelName: "dog"}
    {amount: 3, modelName: "cat"}
    {amount: 1, modelName: "bat"}
  ]
  

test "it works on independent actions", (assert) ->
  {needCores} = action.needs(K)
  assert.deepEqual needCores, []