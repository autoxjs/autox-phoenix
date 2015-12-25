defmodule Autox.ContextUtils do
  defmodule MissingContextError do
    defexception [:message]
  end

  def get(conn, key) do
    conn.params 
    |> Map.get("context", %{})
    |> Map.get(key)
  end
  def get!(conn, key) do
    conn
    |> get(key)
    |> case do
      nil -> raise MissingContextError, message: "expected #{key} to be in the context"
      x -> x
    end
  end

  def put(conn, key, value) do
    default = %{} |> Map.put(key, value)
    params = conn.params
    |> Map.update("context", default, &Map.put(&1, key, value))
    %{conn | params: params}
  end
end