`import createHistory from '../../../utils/create-history'`
`import { module, test } from 'qunit'`
`import _ from 'lodash/lodash'`

module 'Unit | Utility | create history'
{mapValues, chain, omit, partialRight} = _
class FauxModel
  constructor: (@id) ->
  relate: -> @
  associate: (params) -> 
    chain(params)
    .omit(["scheduledAt", "happenedAt"])
    .merge(model: @)
    .value()

class Apple extends FauxModel
  @modelName = "apple"

class Orange extends FauxModel
  @modelName = "orange"

Common =
  name: "apple-orange-test"
  message: "This is a test of the apple-orange history util"

test 'it works on pairs', (assert) ->
  apple = new Apple(77)
  orange = new Orange("blood")
  
  assert.deepEqual createHistory(Common, {apple, orange}),
    apple: 
      model: apple
      mentionedId: "blood"
      mentionedType: "orange"
      type: "pair"
      name: "apple-orange-test"
      message: "This is a test of the apple-orange history util"
    orange:
      model: orange
      mentionedId: 77
      mentionedType: "apple"
      type: "pair"
      name: "apple-orange-test"
      message: "This is a test of the apple-orange history util"

test "it works on singles also", (assert) ->
  apple = new Apple "granny smith"

  assert.deepEqual createHistory(Common, {apple}),
    apple:
      model: apple
      type: "single"
      name: "apple-orange-test"
      mentionedType: "apple"
      mentionedId: "granny smith"
      message: "This is a test of the apple-orange history util"