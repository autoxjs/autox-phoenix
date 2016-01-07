`import DS from 'ember-data'`
`import Ember from 'ember'`
`import {SessionStateMixin} from 'autox'`

Session = DS.Model.extend Ember.Evented, SessionStateMixin,
  <%= for {key, type} <- attrs do %>
  <%= key %>: DS.attr "<%= type %>"
  <% end %>

  <%= for {key, _, related} <- assocs do %>
  <%= key %>: DS.belongsTo "<%= related %>", async: true
  <% end %>

`export default Session`