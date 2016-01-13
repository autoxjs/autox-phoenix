defmodule Autox.SessionUtils do
  import Plug.Conn

  def logged_in?(conn) do
    conn
    |> current_session
    |> case do
      nil -> false
      _ -> true
    end
  end

  def change(conn, session) do
    conn |> put_session(:current_session, session)
  end
  def login(conn, session), do: conn |> put_session(:current_session, session)

  def logout(conn) do
    conn |> delete_session(:current_session)
  end

  def current_session(conn) do
    conn |> get_session(:current_session)
  end

  def current_user(conn) do
    conn
    |> current_session
    |> case do
      nil -> nil
      session -> session |> Map.get(:user)
    end
  end
end