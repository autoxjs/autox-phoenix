defmodule Autox.MetaUtils do
  defstruct resource_path: nil,
    namespace: nil,
    path: nil,
    host: nil,
    type: :unknown,
    valid?: true

  def from_conn(conn) do
    vs = conn.path_info
    |> Enum.reverse
    |> Enum.take(5)
    |> destruct_path
    |> Kernel.++([path: conn.request_path, host: conn.host])

    struct(__MODULE__, vs)
  end

  defp destruct_path([related, "relationships", parent_id, parent, namespace]) do
    [namespace: "/" <> namespace,
    type: :relationship,
    resource_path: [parent, parent_id, "relationships", related] |> Path.join]
  end
  defp destruct_path([related, parent_id, parent, namespace]) do
    [namespace: "/" <> namespace,
    type: :related,
    resource_path: [parent, parent_id, related] |> Path.join]
  end
  defp destruct_path([resource_id, resource, namespace]) do
    [namespace: "/" <> namespace,
    type: :resource,
    resource_path: [resource, resource_id] |> Path.join]
  end
  defp destruct_path([collection, namespace]) do
    [namespace: "/" <> namespace,
    type: :collection,
    resource_path: collection]
  end
  defp destruct_path(_), do: [valid?: false]
end