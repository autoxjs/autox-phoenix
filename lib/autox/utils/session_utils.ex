defmodule Autox.SessionUtils do
  alias Fox.RecordExt
  import Plug.Conn

  def logged_in?(conn) do
    conn
    |> get_session(:current_session)
    |> case do
      nil -> false
      _ -> true
    end
  end

  def change(conn, session) do
    conn |> put_session(:current_session, session |> serialize)
  end

  def login(conn, session) do
    conn |> put_session(:current_session, session |> serialize)
  end

  def logout(conn) do
    conn |> delete_session(:current_session)
  end

  def current_session(conn) do
    conn |> get_session(:current_session) |> deserialize
  end

  def current_user(conn) do
    conn
    |> current_session
    |> case do
      nil -> nil
      session -> session |> Map.get(:user)
    end
  end

  def serialize(%{id: id}), do: id

  def deserialize(nil), do: nil
  def deserialize(id) do
    class = Autox.default_session_class
    repo = Autox.default_repo
    class
    |> repo.get(id)
    |> case do
      nil -> nil
      session -> session |> repo.preload(class.preload_fields)
    end
  end
end
