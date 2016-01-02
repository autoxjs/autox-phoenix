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
    parent = paths 
    |> Enum.reverse 
    |> Enum.take(4)
    |> parent_finder_from_path
    |> apply([base, repo])
    
    params = Map.put(conn.params, "parent", parent)
    %{conn | params: params}
  end

  defp parent_finder_from_path([_model, "relationships", id, parent_name]) do
    &find!(&1, parent_name, id, &2)
  end
  defp parent_finder_from_path([_model, id, parent_name|_]) do
    &find!(&1, parent_name, id, &2)
  end

  defp find!(base, parent_name, id, repo) do
    base
    |> Module.safe_concat(parent_name |> infer_module)
    |> repo.get!(id)
  end

  defp infer_module(parent_name) do
    parent_name |> StringExt.singularize |> StringExt.camelize
  end
end