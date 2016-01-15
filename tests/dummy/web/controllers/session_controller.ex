defmodule Dummy.SessionController do
  use Dummy.Web, :controller
  plug :scrub_params, "data" when action in [:create, :update]
  plug Autox.ChangeSessionPlug when action in [:create, :update, :delete]
  plug Autox.SessionModelPlug when action in [:show, :update, :delete]
  use Autox.ResourceController
end