defmodule Dummy.OwnerController do
  use Dummy.Web, :controller
  
  plug :scrub_params, "data" when action in [:create, :update]
  plug Autox.AutoModelPlug, Dummy.Owner when action in [:show, :update, :delete]
  use Autox.ResourceController
  
end