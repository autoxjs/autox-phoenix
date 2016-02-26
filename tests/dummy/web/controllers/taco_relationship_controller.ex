defmodule Dummy.TacoRelationshipController do
  use Dummy.Web, :controller
  
  plug :scrub_params, "data" when action in [:create, :update, :delete]
  plug Autox.AutoParentPlug, Dummy
  plug Autox.AutoPaginatePlug when action in [:index]
  use Autox.RelationshipController
  
end