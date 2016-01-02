defmodule Autox.NamespaceUtils do
  alias Fox.MapExt
  
  def namespacify_links(list, meta) when is_list(list), do: list |> Enum.map(&namespacify_links(&1, meta))
  def namespacify_links(map, %{namespace: ns}=meta) when is_map(map) and is_binary(ns) do
    map
    |> MapExt.present_update(:links, &namespacify_links_with(&1, meta))
    |> MapExt.present_update(:data, &namespacify_links(&1, meta))
    |> MapExt.present_update(:relationships, &namespacify_relationships(&1, meta))
  end
  def namespacify_links(output, _), do: output

  def namespacify_relationships(relations_map, meta) do
    relations_map |> MapExt.value_map(&namespacify_links(&1, meta))
  end

  defp namespacify_links_with(links, %{namespace: ns}) do
    links 
    |> MapExt.present_update(:self, &Path.join(ns, &1))
    |> MapExt.present_update(:related, &Path.join(ns, &1))
  end
end