defmodule Autox.AuthSessionPlug do
  alias Autox.SessionUtils, as: Su
  alias Autox.ForbiddenUtils, as: Fu
  def init([]), do: {__MODULE__, :exists?}
  def init(method) when is_atom(method), do: {session_class, method}
  def init({module, method}), do: {module, method}

  def call(conn, checker) do
    conn
    |> Su.current_session
    |> permission_check(checker)
    |> case do
      {:ok, _} -> conn
      true -> conn
      {:error, reason} -> conn |> Fu.forbidden(reason)
      nil -> conn |> Fu.forbidden("no reason given")
    end
  end
  defp session_class, do: Autox.default_session_class
  defp permission_check(session, {module, method}) do
    module |> apply(method, [session])
  end

  def exists?(nil), do: {:error, "user not logged in"}
  def exists?(s), do: {:ok, s}
end