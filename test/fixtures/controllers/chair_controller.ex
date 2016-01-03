defmodule Autox.ChairController do
  use Autox.Web, :controller
  
  plug :scrub_params, "data" when action in [:create, :update]
  plug Autox.AutoModelPlug, Autox.Chair when action in [:show, :update, :delete]
  use Autox.ResourceController
  
end