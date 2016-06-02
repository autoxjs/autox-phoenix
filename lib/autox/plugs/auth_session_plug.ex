defmodule Autox.AuthSessionPlug do
  alias Autox.SessionUtils, as: Su
  alias Autox.ForbiddenUtils, as: Fu
  def init([]), do: {Su, :logged_in?}
  def init(method) when is_atom(method), do: {Su, method}
  def init({module, method}), do: {module, method}

  def call(conn, checker) do
    if conn |> permission_check(checker) do
      conn
    else
      conn |> Fu.forbidden("user not logged in")
    end
  end

  defp permission_check(conn, {module, method}), do: apply(module, method, [conn])
end
