defmodule Autox.ForbiddenUtils do
  import Plug.Conn
  import Phoenix.Controller, only: [render: 4]
  def forbidden(conn, detail) do
    conn
    |> put_status(:forbidden)
    |> render(error_view, "403.json", detail: detail)
    |> halt
  end

  defp error_view, do: Autox.default_error_view
end