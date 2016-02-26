defmodule Autox.MetaUtils do
  alias Fox.DictExt
  alias Fox.UriExt
  defstruct resource_path: nil,
    namespace: nil,
    path: nil,
    host: nil,
    type: :unknown,
    valid?: true,
    next_path: nil,
    prev_path: nil,
    this_path: nil,
    other_queries: %{}

  def from_conn(conn), do: from_conn(conn, [])
  def from_conn(conn, models) do
    vs = conn.path_info
    |> Enum.reverse
    |> Enum.take(5)
    |> destruct_path
    |> Kernel.++([path: conn.request_path, host: conn.host])
    |> Kernel.++(link_paths(conn.params, models))
    struct(__MODULE__, vs)
  end

  def links_hash(%{resource_path: path, this_path: this, next_path: next, prev_path: prev, other_queries: other}) do
    %{ self: join_or_nil(path, this), next: join_or_nil(path, next), prev: join_or_nil(path, prev)}
    |> DictExt.reject_blank_keys
    |> attach_query(other)
  end

  defp attach_query(hash, ""), do: hash
  defp attach_query(hash, query) when is_binary(query) do
    hash |> DictExt.value_map(&(&1 <> "&" <> query))
  end
  defp attach_query(hash, _), do: hash

  defp join_or_nil(uri, qs) when is_binary(uri) and is_binary(qs) do
    uri <> "?" <> qs
  end
  defp join_or_nil(_, _), do: nil

  def from_user(user) do
    %__MODULE__{
      resource_path: "users/#{user.id}",
      namespace: "/api",
      type: :resource,
      path: "/api/users/#{user.id}",
      host: "localhost"
    }
  end

  def link_paths(params, models) do
    raw_link_paths(params, models)
    |> Keyword.put(:this_path, params["page"])
    |> DictExt.reject_blank_keys
    |> DictExt.value_map(fn page -> %{"page" => page} end)
    |> Keyword.put(:other_queries, Map.take(params, ["sort", "filter"]))
    |> DictExt.value_map(&UriExt.encode_query/1)
  end
  defp raw_link_paths(%{"page" => page}, []) do
    [prev_path: prev_path(page)]
  end
  defp raw_link_paths(%{"page" => page}, _) do
    [next_path: next_path(page), prev_path: prev_path(page)]
  end
  defp raw_link_paths(_, _), do: []

  defp prev_path(%{"offset" => offset, "limit" => limit}) when offset < limit, do: nil
  defp prev_path(%{"limit" => limit}=params) do
    params |> Map.update!("offset", &(&1 - limit))
  end

  defp next_path(%{"limit" => limit}=params) do
    params |> Map.update!("offset", &(&1 + limit))
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