`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'autox-show-for', 'Integration | Component | autox show for', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{autox-show-for}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#autox-show-for}}
      template block text
    {{/autox-show-for}}
  """

  assert.equal @$().text().trim(), 'template block text'
