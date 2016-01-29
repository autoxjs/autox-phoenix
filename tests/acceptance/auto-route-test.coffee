`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import startApp from '../../tests/helpers/start-app'`
`import moment from 'moment'`

module 'Acceptance: AutoRoute',
  beforeEach: ->
    @application = startApp()
    ###
    Don't return anything, because QUnit looks for a .then
    that is present on Ember.Application, but is deprecated.
    ###
    @lookup = @application.__container__.lookup("service:lookup")
    @route = @application.__container__.lookup("route:application")
    @store = @application.__container__.lookup("service:store")
    return

  afterEach: ->
    Ember.run @application, 'destroy'

test 'visiting /', (assert) ->
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

    visit "/chairs/new"

  andThen =>
    assert.equal currentPath(), "chairs.new"
