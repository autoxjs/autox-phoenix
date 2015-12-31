defmodule Autox.UnderscoreParamsPlug do
  import Plug.Conn
  alias Fox.StringExt
  
  def init, do: "data"
  def init(key), do: key

  def call(%{params: params}=conn, key) do
    %{conn|params: underscore_keys(key, params)}
  end
  def call(conn, _), do: conn

  defp underscore_keys(key, params) do
    case params |> Map.pop(key) do
      {nil, params} -> params
      {value, params} -> 
        params |> Map.put(StringExt.underscore(key), underscore_keys(value))
    end
  end

  defp underscore_keys(map) when is_map(map) do
    map
    |> Map.keys
    |> Enum.reduce(map, &underscore_keys/2)
  end

  defp underscore_keys(list) when is_list(list) do
    list |> Enum.map(&underscore_keys/1)
  end

  defp underscore_keys(value), do: value
end