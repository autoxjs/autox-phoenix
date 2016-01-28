`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'autox-select-choice', 'Integration | Component | autox select choice', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{autox-select-choice}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#autox-select-choice}}
      template block text
    {{/autox-select-choice}}
  """

  assert.equal @$().text().trim(), 'template block text'
