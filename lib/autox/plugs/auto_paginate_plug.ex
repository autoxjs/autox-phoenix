defmodule Autox.AutoPaginatePlug do
  alias Fox.MapExt
  @default_opts [offset: 0, limit: 25, max_limit: 100, sort: "-id"]
  def init([]), do: @default_opts
  def init(opts) when is_list(opts), do: @default_opts |> Keyword.merge(opts)

  def call(conn, [offset: offset, limit: limit, max_limit: ulimit, sort: sort]) do
    params = conn.params
    |> numerify_pages
    |> consider_offset(offset)
    |> consider_limit(limit, ulimit)
    |> consider_sort(sort)
    %{conn | params: params}
  end

  defp consider_offset(params, offset) do
    params 
    |> Map.update("page", %{"offset" => offset}, &Map.put_new(&1, "offset", offset))
  end
  defp consider_limit(params, limit, ulimit) do
    params 
    |> Map.update("page", %{"limit" => limit}, &to_the_limit(&1, limit, ulimit))
  end
  defp to_the_limit(page, limit, ulimit) do
    page |> Map.update("limit", limit, &cap_at(&1, ulimit))
  end
  defp cap_at(str, b) when is_binary(str), do: str |> parse_int |> cap_at(b)
  defp cap_at(x, _) when x < 0, do: 0
  defp cap_at(x, bound) when x > bound, do: bound
  defp cap_at(x, _), do: x
  defp consider_sort(params, sort) do
    params |> Map.put_new("sort", sort)
  end

  defp parse_int(int) when is_integer(int), do: int
  defp parse_int(str) do
    case Integer.parse(str) do
      {i, _} -> i
      :error -> 0
    end
  end

  defp numerify_pages(%{"page" => page}=params) when is_map(page) do
    f = &parse_int/1
    params |> Map.update!("page", &MapExt.value_map(&1, f))
  end
  defp numerify_pages(params), do: params
end