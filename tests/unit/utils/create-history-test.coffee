`import Ember from 'ember'`
`import {createHistory, persistHistory} from 'autox/utils/create-history'`
`import { module, test } from 'qunit'`
`import _ from 'lodash/lodash'`
{RSVP} = Ember
module 'Unit | Utility | create history'
{mapValues, chain, omit, partialRight} = _
class FauxModel
  constructor: (@id) ->
  relate: -> @
  associate: (params) -> 
    chain(params)
    .omit(["scheduledAt", "happenedAt"])
    .merge(model: @, save: @save)
    .value()
  save: -> RSVP.resolve("ok")


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
      save: apple.save
      mentionedId: "blood"
      mentionedType: "orange"
      type: "pair"
      name: "apple-orange-test"
      message: "This is a test of the apple-orange history util"
    orange:
      model: orange
      save: orange.save
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
      save: apple.save
      type: "single"
      name: "apple-orange-test"
      mentionedType: "apple"
      mentionedId: "granny smith"
      message: "This is a test of the apple-orange history util"

test "persistHistory should work as expected", (assert) ->
  assert.expect 1
  apple = new Apple(77)
  orange = new Orange("blood")
  
  persistHistory(Common, {apple, orange})
  .then (results) ->
    assert.deepEqual results,
      apple: "ok"
      orange: "ok"

test "persistHistory should work as expected on singles also", (assert) ->
  assert.expect 1
  orange = new Orange "Texas"
  
  persistHistory(Common, {orange})
  .then (results) ->
    assert.deepEqual results,
      orange: "ok"
