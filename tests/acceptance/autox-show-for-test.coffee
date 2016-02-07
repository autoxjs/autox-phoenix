`import Ember from 'ember'`
`import { module, test } from 'qunit'`
`import startApp from '../../tests/helpers/start-app'`

module 'Acceptance: AutoxShowFor',
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

test 'checking correct auto rendering', (assert) ->
  
  visit "/autox-show-for"


