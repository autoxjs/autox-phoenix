defmodule Dummy.KitchenView do
  use Dummy.Web, :view
  
  @relationships ~w( shop )a
  use Autox.ResourceView
  
end