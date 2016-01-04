defmodule Dummy.OwnerView do
  use Dummy.Web, :view
  
  @relationships ~w( shops )a
  use Autox.ResourceView
  
end