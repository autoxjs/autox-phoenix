`import DS from 'ember-data'`
`import {RelateableMixin} from 'autox'`

Model = DS.Model.extend RelateableMixin,
  <%= for {key, type} <- attrs do %>
  <%= key %>: DS.attr "<%= type %>"
  <% end %>

  <%= for {key, cardinality, related} <- assocs do %>
  <%= key %>: DS.<%= cardinality %> "<%= related %>", async: true
  <% end %>

`export default Model`