defmodule Dummy.ShopView do
  use Dummy.Web, :view
  
  @relationships ~w( kitchen owner chairs salsas tacos histories )a
  use Autox.ResourceView
  
end