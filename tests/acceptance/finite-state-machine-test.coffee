`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import startApp from '../../tests/helpers/start-app'`
`import hbs from 'htmlbars-inline-precompile'`

module 'Acceptance: FiniteStateMachine',
  beforeEach: ->
    @application = startApp()
    ###
    Don't return anything, because QUnit looks for a .then
    that is present on Ember.Application, but is deprecated.
    ###
    @fsm = @application.__container__.lookup("service:finite-state-machine")
    return

  afterEach: ->
    Ember.run @application, 'destroy'

test 'updating the fsm', (assert) ->
  @application.register "template:finite-state-machine", hbs """
    <div id="display">{{fsm.prev}}</div>
    <button id="first" {{action (action (mut fsm.prev) "tfwnogf") on="click"}}>
      Friday Night
    </button>
    <button id="second" {{action (action (mut fsm.prev) "stillnogf") on="click"}}>
      Saturday Night
    </button>
    <button id="third" {{action (action (mut fsm.prev) "dreamofwork") on="click"}}>
      Sunday Night
    </button>
  """

  visit "/finite-state-machine"

  andThen =>
    assert.equal currentURL(), "/finite-state-machine"

    click "#first"

  andThen =>
    assert.equal @fsm.get("prev"), "tfwnogf"
    assert.equal find("#display").text(), "tfwnogf"
    click "#second"

  andThen =>
    assert.equal @fsm.get("prev"), "stillnogf"
    assert.equal find("#display").text(), "stillnogf"
    assert.equal @fsm.get("states.firstObject"), "tfwnogf"

    click "#third"

  andThen =>
    assert.equal @fsm.get("prev"), "dreamofwork"
    assert.equal find("#display").text(), "dreamofwork"
    assert.equal @fsm.get("states.firstObject"), "stillnogf"
    assert.equal @fsm.get("states.length"), 2

