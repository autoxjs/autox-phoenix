defmodule Dummy.SessionView do
  use Dummy.Web, :view
  
  @relationships ~w(user owner)a
  use Autox.ResourceView
  
end