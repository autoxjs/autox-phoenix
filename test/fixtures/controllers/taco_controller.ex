defmodule Autox.TacoController do
  use Autox.Web, :controller
  
  plug :scrub_params, "data" when action in [:create, :update]
  plug Autox.AutoModelPlug, Autox.Taco when action in [:show, :update, :delete]
  use Autox.ResourceController
  
end