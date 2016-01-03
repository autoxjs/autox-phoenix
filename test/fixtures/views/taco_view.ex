defmodule Autox.TacoView do
  use Autox.Web, :view
  
  @relationships ~w(shops )a
  use Autox.ResourceView
  
end