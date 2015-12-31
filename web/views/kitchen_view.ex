defmodule Autox.KitchenView do
  use Autox.Web, :view
  
  @relationships ~w( shop )a
  use Autox.ResourceView
  
end