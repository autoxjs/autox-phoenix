`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import startApp from '../../tests/helpers/start-app'`
`import {QueryUtils} from 'autox'`

module 'Acceptance: Query',
  beforeEach: ->
    @application = startApp()
    ###
    Don't return anything, because QUnit looks for a .then
    that is present on Ember.Application, but is deprecated.
    ###
    @store = @application.__container__.lookup("service:store")
    return

  afterEach: ->
    Ember.run @application, 'destroy'

test 'visiting /', (assert) ->
  visit '/'

  andThen =>
    query = new QueryUtils()
    query.orderBy "name", "desc"
    query.filterBy "insertedAt", ">=", moment()
    query.filterBy "insertedAt", "!<", moment()
    query.pageBy offset: 1, limit: 3
    @store
    .query "shop", query.toParams()
    .then (shops) =>
      assert.ok shops
