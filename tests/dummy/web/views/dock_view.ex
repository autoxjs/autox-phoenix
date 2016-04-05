defmodule Dummy.DockView do
  use Dummy.Web, :view
  
  @relationships ~w( trucks )a
  use Autox.ResourceView
  
end