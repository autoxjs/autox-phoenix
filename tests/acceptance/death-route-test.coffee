`import { test } from 'qunit'`
`import moduleForAcceptance from '../../tests/helpers/module-for-acceptance'`
`import Index from 'dummy/tests/pages/index'`

moduleForAcceptance 'Acceptance: DeathRoute'

test 'visiting /', (assert) ->
  @lookup = @application.__container__.lookup("service:lookup")
  @route = @application.__container__.lookup("route:application")
  @store = @application.__container__.lookup("service:store")

  Index.login()

  andThen =>
    visit '/chairs'

  andThen =>
    assert.equal currentPath(), "chairs.index"
    assert.ok @lookup.template("application"), "should find application"
    assert.notOk @lookup.template("dogs/index"), "should not find random crap"
    assert.notOk @lookup.template("dogs.index"), "should not find random crap"

    @store.pushPayload "chair",
      data:
        id: 666
        type: "chairs"
        attributes:
          insertedAt: moment()
          size: "haes"
          updatedAt: moment()

  andThen =>
    @chair = @store.peekRecord "chair", 666
    assert.ok @chair
    assert.equal @chair.constructor.modelName, "chair"
    assert.equal @chair.id, 666

    assert.equal @route.defaultModelShowPath(@chair.constructor), "chair.index"
    visit "/chairs/new"

  andThen =>
    assert.equal currentPath(), "chairs.new"
