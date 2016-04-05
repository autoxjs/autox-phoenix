`import Ember from 'ember'`
`import { test } from 'qunit'`
`import moduleForAcceptance from '../../tests/helpers/module-for-acceptance'`
`import Query from 'autox/utils/query'`
`import ShopsIndex from 'dummy/tests/pages/shops/index'`
`import moment from 'moment'`
`import _ from 'lodash/lodash'`

moduleForAcceptance 'Acceptance: Query'

test 'visiting /', (assert) ->
  @store = @application.__container__.lookup("service:store")
  
  visit '/shops'

  andThen =>
    assert.equal currentPath(), "shops.index"
    assert.ok ShopsIndex.shopCount() <= 25, "we should have 25 shops due to the page params"

    ShopsIndex.changeLimit 5

  andThen =>
    assert.ok ShopsIndex.shopCount() <= 5, "changing the page limit should reduce the amount of stuff shown"
    @firstId = parseInt ShopsIndex.firstShopId()
    ShopsIndex.nextPage()

  andThen =>
    currentId = parseInt ShopsIndex.firstShopId()
    assert.equal currentId + 5, @firstId, "we should change page by the right offset amount"