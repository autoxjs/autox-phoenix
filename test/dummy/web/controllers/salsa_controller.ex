defmodule Dummy.SalsaController do
  use Dummy.Web, :controller
  
  plug :scrub_params, "data" when action in [:create, :update]
  plug Autox.AutoModelPlug, Dummy.Salsa when action in [:show, :update, :delete]
  use Autox.ResourceController
  
end