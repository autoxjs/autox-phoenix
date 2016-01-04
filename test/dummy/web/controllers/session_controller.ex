defmodule Dummy.SessionController do
  use Dummy.Web, :controller
  @repo Autox.EchoRepo
  plug :scrub_params, "data" when action in [:create, :update]
  plug Autox.SessionModelPlug when action in [:show, :update, :delete]
  use Autox.ResourceController
  
end