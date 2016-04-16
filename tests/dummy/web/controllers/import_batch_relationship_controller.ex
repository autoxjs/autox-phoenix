defmodule Dummy.ImportBatchRelationshipController do
  use Dummy.Web, :controller
  
  plug :scrub_params, "data" when action in [:create, :update, :delete]
  plug Autox.AutoPaginatePlug when action in [:index]
  plug Autox.AutoParentPlug, Dummy
  use Autox.RelationshipController
  
end