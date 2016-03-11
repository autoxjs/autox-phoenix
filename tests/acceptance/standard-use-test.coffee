`import Ember from 'ember'`
`import { test } from 'qunit'`
`import moduleForAcceptance from '../../tests/helpers/module-for-acceptance'`

moduleForAcceptance 'Acceptance: StandardUse'

test 'visiting /', (assert) ->
  @store = @application.__container__.lookup("service:store")
  visit '/'

  ctx = {}
  andThen =>
    assert.equal currentURL(), '/'
    assert.equal typeof @store?.createRecord, "function", "we should have the store"
    ctx.owner = @store.createRecord "owner",
      name: "test-owner-freddy"
    ctx.owner.save()
  andThen =>
    owner = ctx.owner
    assert.ok owner, "we should have made an owner"
    assert.equal owner.get("name"), "test-owner-freddy", "it should handle attributes correctly"
    factory = @store.modelFor "owner"
    assert.equal owner.constructor, factory, "it should be what we expect"
  andThen =>
    ctx.shop = @store.createRecord "shop",
      owner: ctx.owner
      name: "jackson Davis Shop"
      location: "nowhere"
    ctx.shop.save()
  andThen =>
    {shop} = ctx
    assert.ok shop
    assert.equal shop.get("name"), "jackson Davis Shop", "the attributes should match"
    shop.get("owner")
    .then (owner) ->
      assert.equal owner.get("id"), ctx.owner.get("id"), "ok relationship"
  andThen =>
    ctx.salsa = @store.createRecord "salsa",
      name: "avocado mild"
      price: 1.34
    ctx.salsa.save()
  andThen =>
    {shop, salsa} = ctx
    assert.equal typeof shop.relate, "function", "models should have the relate function"
    ctx.relation = (relation = shop.relate "salsas")
    relation.associate salsa
    relation.set "authorization-key", "x-fire"
    relation.save()
  andThen =>
    {shop, salsa} = ctx
    shop.get("salsas")
    .then (salsas) ->
      assert.equal salsas.get("length"), 1, "we should have a salsa at the shop"
      s = salsas.objectAt(0)
      assert.equal s.get("id"), salsa.get("id"), "the salsas should match"
  andThen =>
    {relation} = ctx
    relation.destroyRecord()
  andThen =>
    {shop} = ctx
    shop
    .get("salsas")
    .then (salsas) ->
      salsas.reload()
    .then (salsas) ->
      assert.equal salsas.get("length"), 0, "deleting the relation should empty out the relation"