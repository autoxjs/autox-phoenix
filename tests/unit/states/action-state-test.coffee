`import action from 'autox/utils/action'`
`import ActionState from 'autox/states/action-state'`
`import { module, test } from 'qunit'`
`import Ember from 'ember'`

{K} = Ember

module 'Unit | States | ActionState'

class Dog
  @modelName = "dog"

class Cat
  @modelName = "cat"

class Rat
  @modelName = "rat"

test "fulfillment and destruct", (assert) ->
  actionState = ActionState.create action.needs("dog", "cat", "rat:2", K)
  dog = new Dog()
  cat = new Cat()
  rat = new Rat()

  assert.ok actionState.stillNeeds(dog), "we should need a dog at first"
  assert.notOk actionState.stillNeeds(cat), "we should not need a cat yet"
  assert.notOk actionState.stillNeeds(rat), "we should not need a rat yet"
  assert.equal actionState.get("activeModelname"), "dog", "we need dogs first"

  actionState.fulfillNextNeed(dog)

  assert.equal actionState.get("activeModelname"), "cat", "we should need a cat now"
  assert.notOk actionState.stillNeeds(dog), "we should no longer need a dog"
  assert.ok actionState.stillNeeds(cat), "we should now need a cat"
  assert.notOk actionState.stillNeeds(rat), "we should not need a rat yet"

  actionState.fulfillNextNeed(cat)

  assert.notOk actionState.stillNeeds(dog), "we should no longer need a dog"
  assert.notOk actionState.stillNeeds(cat), "we should no longer need a cat"
  assert.ok actionState.stillNeeds(rat), "we should now need a rat"
  assert.equal actionState.get("activeModelname"), "rat", "we the name of the need should be rat"

  actionState.fulfillNextNeed(rat)

  assert.notOk actionState.stillNeeds(dog), "we should no longer need a dog"
  assert.notOk actionState.stillNeeds(cat), "we should no longer need a cat"
  assert.ok actionState.stillNeeds(rat), "we should now need a rat"
  assert.equal actionState.get("activeModelname"), "rat", "we the name of the need should be rat"

  actionState.fulfillNextNeed(rat)

  assert.ok actionState.get("allFulfilled"), "everything should be fulfilled"
  assert.notOk actionState.stillNeeds(dog), "we should no longer need a dog"
  assert.notOk actionState.stillNeeds(cat), "we should no longer need a cat"
  assert.notOk actionState.stillNeeds(rat), "we should no longer need a rat"
  assert.deepEqual actionState.destruct(), {dog, cat, rat: [rat, rat]}