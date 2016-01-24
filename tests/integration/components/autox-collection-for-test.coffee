`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'autox-collection-for', 'Integration | Component | autox collection for', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{autox-collection-for}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#autox-collection-for}}
      template block text
    {{/autox-collection-for}}
  """

  assert.equal @$().text().trim(), 'template block text'
