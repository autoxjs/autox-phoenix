defmodule Autox.OwnerController do
  use Autox.Web, :controller
  
  plug :scrub_params, "data" when action in [:create, :update]
  plug Autox.AutoModelPlug, Autox.Owner when action in [:create, :show, :update, :delete]
  use Autox.ResourceController
  
end