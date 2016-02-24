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
  dog = new Dog()
  cat = new Cat()
  rat = new Rat()

  assert.ok action.needs
  f = action.needs("dog", "cat:2", "rat:many")
  assert.equal typeof f.next, "function", "it is an iterator"
  assert.equal typeof f.return, "function", "it is an generator iterator"

  {value: dogNeed, done} = f.next()
  assert.ok dogNeed, "we should have a value"
  assert.equal done, false, "we're just getting started"

  assert.notOk dogNeed.get("isFulfilled"), "we should not be fulfilled yet"
  assert.equal dogNeed.get("modelName"), "dog", "I expect a dog to be the ordered need"
  assert.equal dogNeed.get("amount"), 1, "I expect to need 1 dog"

  assert.ok dogNeed.stillNeeds(dog), "we need dog"
  assert.notOk dogNeed.stillNeeds(cat), "not cat"
  assert.notOk dogNeed.stillNeeds(rat), "nor rat"

  {value: catNeed, done} = f.next(dog)
  assert.notOk done, "we should not be done yet"
  assert.ok dogNeed.get("isFulfilled"), "we should have satisfied the dog need"
  assert.equal catNeed.get("modelName"), "cat", "we should have a cat need"
  assert.equal catNeed.get("amount"), 2, "we should need 2 cats"

  {value: catNeed, done} = f.next(cat)
  assert.notOk done, "we are still not done"
  assert.notOk catNeed.get("isFulfilled") , "we haven't satisfied the cat yet"
  assert.equal catNeed.get("modelName"), "cat", "we should still have a cat need"
  assert.equal catNeed.get("amount"), 2, "we should need 2 cats total"
  assert.equal catNeed.get("goods.length"), 1, "we should have 1 cat"

  {value: ratNeed, done} = f.next(cat)
  assert.notOk done, "we are almost done, but not quite"
  assert.ok catNeed.get("isFulfilled"), "the cats should be satisfied"
  assert.equal ratNeed.get("modelName"), "rat", "we should need a rat now"
  assert.equal ratNeed.get("amount"), 1, "we should need 1 rat now"

  {value: goods, done} = f.next(rat)
  assert.ok done, "we should be done now"
  assert.ok ratNeed.get("isFulfilled"), "the rats should be satisfied"
  assert.deepEqual goods,
    dog: dog
    cat: [cat, cat]
    rat: rat