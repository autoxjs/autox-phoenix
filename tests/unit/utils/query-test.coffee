`import Ember from 'ember'`
`import Query from 'autox/utils/query'`
`import moment from 'moment'`
`import _ from 'lodash/lodash'`
`import _x from 'autox/utils/xdash'`
`import { module, test } from 'qunit'`

{times} = _
{A} = Ember
{tapLog} = _x

class FauxShop
  constructor: (@insertedAt, @name) ->
    @insertedAt ?= moment()
    @name ?= Math.random()

module 'Unit | Utility | query'

# Replace this with your real tests.
test 'it works', (assert) ->
  assert.ok Query, "we should have the query tool"

test 'it generates the right query', (assert) ->
  now = 10
  query = new Query()
  .orderBy "name", "desc"
  .filterBy "insertedAt", ">=", now
  .filterBy "insertedAt", "!<", now
  .pageBy offset: 1, limit: 3

  assert.deepEqual query.toParams(),
    page:
      offset: 1
      limit: 3
    sort: ["-name"]
    filter: 
      inserted_at: [">=#{now}", "!<#{now}"]

test "it should parse the local query params", (assert) ->
  query = Query.parse
    pageLimit: 3
    pageOffset: 0
    sortField: "name,identity"
    sortDir: "desc,asc"
    filterField: "insertedAt,insertedAt"
    filterOp: ">=,!<"
    filterValue: "33,1"

  assert.deepEqual query.toParams(),
    page:
      offset: 0
      limit: 3
    sort: ["-name", "identity"]
    filter:
      inserted_at: [">=33", "!<1"]

test "it should ignore shitty local queries", (assert) ->
  query = Query.parse
    pageLimit: 3
    sortField: "name"
    sortDir: "desc,asc"
    filterField: "insertedAt,insertedAt"
    filterOp: ">=,!<"
    filterValue: "33,1"

  assert.deepEqual query.toParams(),
    page: {}
    sort: ["-name"]
    filter:
      inserted_at: [">=33", "!<1"]

test 'it generates the right function', (assert) ->
  query = new Query()
  .orderBy "name", "desc"
  .filterBy "insertedAt", ">=", 10
  .filterBy "insertedAt", "!<", 10
  .pageBy offset: 1, limit: 3

  shopJack = new FauxShop 11, "jack's tobacco"
  shopJill = new FauxShop 9, "jill's meth"
  shopHill = new FauxShop 10, "hill's beanstock"
  shopGiant = new FauxShop 13, "giant's home loans"

  filterFun = query.makeFilterFun()
  assert.equal filterFun(shopJack), true, "jack shop should be there"
  assert.equal filterFun(shopJill), false, "jill shop should not"

  assert.deepEqual query.sortFun(A [shopJill, shopGiant, shopHill, shopJack]),
    A([shopGiant, shopHill, shopJack, shopJill]).reverse()

  f = query.toFunction()

  assert.deepEqual f(A [shopJill, shopHill, shopJack, shopGiant]),
    A([shopGiant, shopHill, shopJack]).reverse()

  assert.deepEqual f(A []), A([]), "blank arrays should be ok"