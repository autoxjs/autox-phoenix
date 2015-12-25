defmodule Autox.AutoParentPlug do
  import Plug.Conn
  alias Fox.StringExt
  alias Autox.ContextUtils
  
  def init(base), do: base

  def call(conn, base) do
    conn |> auto_parent(base)
  end

  defp auto_parent(%{path_info: paths}=conn, base) when is_list(paths) do
    repo = conn |> ContextUtils.get!(:repo)
    parent = paths |> Enum.reverse |> parent_from_flipped_path(conn.params, base, repo)
    
    params = Map.put(conn.params, "parent", parent)
    %{conn | params: params}
  end

  defp parent_from_flipped_path([_model, "relationships", id, parent_name|_], params, base, repo) do
    base
    |> Module.safe_concat(parent_name |> infer_module)
    |> repo.get!(id)
  end

  defp infer_module(parent_name) do
    parent_name |> StringExt.singularize |> StringExt.camelize
  end
end