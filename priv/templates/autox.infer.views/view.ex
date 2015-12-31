defmodule <%= base %>.<%= model %>View do
  use <%= base %>.Web, :view
  <%= if relational_type? do %>
  use Autox.RelationshipView
  <% else %>
  @relationships ~w( <%= for key <- relationships do %><%= key %> <% end %>)a
  use Autox.ResourceView
  <% end %>
end