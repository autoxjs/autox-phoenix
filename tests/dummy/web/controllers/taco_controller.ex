defmodule Dummy.TacoController do
  use Dummy.Web, :controller
  
  plug :scrub_params, "data" when action in [:create, :update]
  plug Autox.AutoModelPlug, Dummy.Taco when action in [:show, :update, :delete]
  plug Autox.AutoPaginatePlug when action in [:index]
  use Autox.ResourceController
  
end