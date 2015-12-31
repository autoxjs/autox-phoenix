defmodule Autox.OwnerView do
  use Autox.Web, :view
  
  @relationships ~w(shops )a
  use Autox.ResourceView
  
end