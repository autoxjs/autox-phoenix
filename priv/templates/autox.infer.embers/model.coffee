`import DS from 'ember-data'`

<%= model %> = DS.Model.extend
  <%= for {key, type} <- attrs do %>
  <%= key %>: DS.attr "<%= type %>"
  <% end %>

  <%= for {key, relation, value} <- assocs do %>
  <%= key %>: DS.<%= camelize relation %> "<%= value %>", async: true
  <% end %>

`export default <%= model %>`