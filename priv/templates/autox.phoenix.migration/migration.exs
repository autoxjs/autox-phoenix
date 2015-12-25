defmodule <%= base %>.Repo.Migrations.<%= if create? do %>Create<% else %>Alter<% end %><%= scoped %> do
  use Ecto.Migration

  def change do
    <%= if create? do %>create<% else %>alter<% end %> table(:<%= plural %><%= if binary_id do %>, primary_key: false<% end %>) do
<%= if binary_id do %>      add :id, :binary_id, primary_key: true
<% end %><%= for {k, v} <- attrs do %>      add <%= inspect k %>, <%= inspect v %><%= defaults[k] %>
<% end %><%= for {_, i, _, s} <- assocs do %>      add <%= inspect i %>, references(<%= inspect(s) %>, on_delete: :nothing<%= if binary_id do %>, type: :binary_id<% end %>)
<% end %>
      <%= if create? do %>timestamps<% end %>
    end
<%= for index <- indexes do %>    <%= index %>
<% end %>
  end
end