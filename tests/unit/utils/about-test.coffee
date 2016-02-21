`import Ember from 'ember'`
`import about from 'autox/utils/about'`
`import { module, test } from 'qunit'`

module 'Unit | Utility | about'

Dog = Ember.Object.extend({})

about Dog,
  label: "Dog"
  description: "An animal"

# Replace this with your real tests.
test 'it works', (assert) ->
  assert.deepEqual Dog.aboutMe,
    label: "Dog"
    description: "An animal"
