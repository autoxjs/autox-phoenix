defmodule Mix.Tasks.Autox.Infer.Views do
  alias Fox.StringExt
  use Mix.Task
  @shortdoc """
  Scaffolds views after inferring from the `router.ex` file
  """
  def run(_) do
    Mix.Task.run "compile", []
    Mix.Phoenix.base
    |> Module.safe_concat("Router")
    |> apply(:__routes__, [])
    |> Enum.map(&parent_ids/1)
    |> Enum.reduce(%{}, &path_associations/2)
    |> Enum.map(&scaffold/1)
  end

  def scaffold({controller, fields}) do
    binding = controller |> Mix.Autox.ctrl_2_model |> Mix.Autox.inflect |> Kernel.++([relationships: fields])
    model = binding[:model] |> StringExt.underscore
    paths = Mix.Autox.paths
    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.views", "", binding, [
      {:eex, "view.ex", "web/views/#{model}_view.ex"}
    ]
  end

  @parent_id ~r/:[a-z0-9_]+_id/
  defp parent_ids(route) do
    Map.get(route, :path) 
    |> String.replace(@parent_id, ":id")
    |> StringExt.consume("/")
    |> case do
      {:ok, path} -> %{route|path: path}
      {:error, path} -> %{route|path: path}
    end
  end
    
  defp path_associations(%{path: path, plug: ctrl}, map) do
    case path |> String.split("/") |> Enum.take(5) do
      [_api, collection, ":id", "relationships", field] ->
        Map.put_new(map, ctrl, [])
        |> Map.update(controlify(collection), [field], &unique_append(&1, field))
      [_api, collection, ":id", field] ->
        Map.put_new(map, ctrl, [])
        |> Map.update(controlify(collection), [field], &unique_append(&1, field))
      [_api, collection, ":id"] ->
        map |> Map.put_new(controlify(collection), [])
      [_api, collection] ->
        map |> Map.put_new(controlify(collection), [])
      _ -> map
    end
  end

  defp unique_append(fields, field), do: if field in fields, do: fields, else: [field|fields]

  defp controlify(collection) do
    Mix.Phoenix.base 
    |> Module.safe_concat collection
    |> StringExt.singularize
    |> StringExt.camelize
    |> Kernel.<>("Controller")
  end

  @moduledoc """
  %Phoenix.Router.Route{assigns: %{}, helper: "chair_shop_relationship",
   host: nil, kind: :match, opts: :show, path: "/api/chairs/:chair_id/shop",
   pipe_through: [:api], plug: Dummy.ShopRelationshipController, private: %{},
   verb: :get}
  %Phoenix.Router.Route{assigns: %{}, helper: "chair_shop_relationship",
   host: nil, kind: :match, opts: :create,
   path: "/api/chairs/:chair_id/relationships/shop", pipe_through: [:api],
   plug: Dummy.ShopRelationshipController, private: %{}, verb: :post}
  %Phoenix.Router.Route{assigns: %{}, helper: "chair_shop_relationship",
   host: nil, kind: :match, opts: :delete,
   path: "/api/chairs/:chair_id/relationships/shop", pipe_through: [:api],
   plug: Dummy.ShopRelationshipController, private: %{}, verb: :delete}
  %Phoenix.Router.Route{assigns: %{}, helper: "session", host: nil, kind: :match,
   opts: :create, path: "/api/sessions", pipe_through: [:api],
   plug: Dummy.SessionController, private: %{}, verb: :post}
  %Phoenix.Router.Route{assigns: %{}, helper: "user", host: nil, kind: :match,
   opts: :create, path: "/api/users", pipe_through: [:api],
   plug: Dummy.UserController, private: %{}, verb: :post}
  """
end