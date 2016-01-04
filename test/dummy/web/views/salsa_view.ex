defmodule Dummy.SalsaView do
  use Dummy.Web, :view
  
  @relationships ~w( shops )a
  use Autox.ResourceView
  
end