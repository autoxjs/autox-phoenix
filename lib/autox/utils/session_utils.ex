defmodule Autox.SessionUtils do
  import Plug.Conn
  alias Autox.EchoRepo, as: Repo

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
    ||
    conn |> session_from_header
  end

  def current_user(conn) do
    conn
    |> current_session
    |> case do
      nil -> nil
      session -> session |> Map.get(:user)
    end
  end

  defp session_from_header(conn) do
    conn
    |> get_req_header("autox-remember-token")
    |> List.first
    |> find_session_by_remember_token
  end

  defp find_session_by_remember_token(nil), do: nil
  defp find_session_by_remember_token(token) do
    session_class
    |> session_class.create_changeset(%{"remember_token" => token})
    |> Repo.insert
    |> case do
      {:ok, session} -> session
      {:error, _} -> nil
    end
  end

  defp session_class do
    Autox.default_session_class
  end
end