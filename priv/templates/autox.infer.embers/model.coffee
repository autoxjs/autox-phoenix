`import DS from 'ember-data'`
`import {Mixins} from 'autox'`
{Relateable} = Mixins
Model = DS.Model.extend Relateable,
  <%= for {key, type} <- attrs do %>
  <%= key %>: DS.attr "<%= type %>"
  <% end %>

  <%= for {key, cardinality, related} <- assocs do %>
  <%= key %>: DS.<%= cardinality %> "<%= related %>", async: true
  <% end %>

`export default Model`