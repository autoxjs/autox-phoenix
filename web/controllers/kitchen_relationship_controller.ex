defmodule Autox.KitchenRelationshipController do
  use Autox.Web, :controller
  
  plug :scrub_params, "data" when action in [:create, :update, :delete]
  plug Autox.AutoParentPlug, Autox
  use Autox.RelationshipController
  
end