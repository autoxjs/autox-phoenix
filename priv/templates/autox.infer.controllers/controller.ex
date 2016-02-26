defmodule <%= base %>.<%= model %>Controller do
  use <%= base %>.Web, :controller
  <%= if relational_type? do %>
  plug :scrub_params, "data" when action in [:create, :update, :delete]
  plug Autox.AutoPaginatePlug when action in [:index]
  plug Autox.AutoParentPlug, <%= base %>
  use Autox.RelationshipController
  <% else %>
  plug :scrub_params, "data" when action in [:create, :update]
  plug Autox.AutoModelPlug, <%= base %>.<%= model %> when action in [:show, :update, :delete]
  plug Autox.AutoPaginatePlug when action in [:index]
  use Autox.ResourceController
  <% end %>
end