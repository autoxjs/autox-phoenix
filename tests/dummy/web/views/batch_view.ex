defmodule Dummy.BatchView do
  use Dummy.Web, :view
  
  @relationships ~w( export_appointment import_appointment )a
  use Autox.ResourceView
  
end