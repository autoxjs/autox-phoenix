defmodule Autox.ShopView do
  use Autox.Web, :view
  
  @relationships ~w(owner salsas tacos )a
  use Autox.ResourceView
  
end