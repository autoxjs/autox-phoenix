defmodule Dummy.AppointmentView do
  use Dummy.Web, :view
  
  @relationships ~w( export_batches import_batches )a
  use Autox.ResourceView
  
end