`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import startApp from '../../tests/helpers/start-app'`

module 'Acceptance: Workflow',
  beforeEach: ->
    @application = startApp()
    ###
    Don't return anything, because QUnit looks for a .then
    that is present on Ember.Application, but is deprecated.
    ###
    @lookup = @application.__container__.lookup("service:lookup")
    return

  afterEach: ->
    Ember.run @application, 'destroy'

test 'visiting /', (assert) ->
  visit '/'

  andThen =>
    assert.equal currentURL(), '/'
    assert.ok @lookup, "the lookup service should be present"
    @workflow = @lookup.other("service:workflow")
    assert.ok @workflow, "it should have successfully looked up the workflow"

    @workflow.update "dummy", 44
    assert.equal 44, @workflow.fetch "dummy"
