defmodule Dummy.SalsaView do
  use Dummy.Web, :view
  
  @relationships ~w( shops histories )a
  use Autox.ResourceView
  
end