defmodule <%= base %>.<%= model %>View do
  use <%= base %>.Web, :view
  <%= if relational_type? do %>
  use Autox.RelationshipView
  <% else %>
  use Autox.ResourceView
  <% end %>
end