`import Ember from 'ember'`
`import faker from 'faker'`
`import { test } from 'qunit'`
`import moduleForAcceptance from 'dummy/tests/helpers/module-for-acceptance'`
`import ShopsNew from 'dummy/tests/pages/shops/new'`

{RSVP} = Ember
moduleForAcceptance 'Acceptance: PowerSelectTest'

test "it should proper power select", (assert) ->
  ShopsNew.visit()

  andThen ->
    ShopsNew.createShop()

  andThen ->
    assert.equal currentPath(), "shops.shop.index",
      "we should have successfully created a shop and be redirect to it"
