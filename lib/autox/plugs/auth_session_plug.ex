defmodule Autox.AuthSessionPlug do
  import Plug.Conn
  alias Autox.SessionUtils
  import Phoenix.Controller, only: [render: 4]

  def init([]), do: {__MODULE__, :exists?}
  def init(method) when is_atom(method), do: {session_class, method}
  def init({module, method}), do: {module, method}

  def call(conn, checker) do
    conn
    |> SessionUtils.current_session
    |> permission_check(checker)
    |> case do
      {:ok, _} -> conn
      {:error, reason} -> conn |> forbidden(reason)
    end
  end

  defp forbidden(conn, detail) do
    conn
    |> put_status(:forbidden)
    |> render(error_view, "403.json", detail: detail)
    |> halt
  end

  defp permission_check(session, {module, method}) do
    module |> apply(method, [session])
  end

  defp error_view, do: Autox.default_error_view
  defp session_class, do: Autox.default_session_class
  def exists?(nil), do: {:error, "user not logged in"}
  def exists?(s), do: {:ok, s}
end