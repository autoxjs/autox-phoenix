`import DS from 'ember-data'`

Model = DS.Model.extend
  <%= for {key, type} <- attrs do %>
  <%= key %>: DS.attr "<%= type %>"
  <% end %>

  <%= for {key, cardinality, related} <- assocs do %>
  <%= key %>: DS.<%= cardinality %> "<%= related %>", async: true
  <% end %>

`export default Model`