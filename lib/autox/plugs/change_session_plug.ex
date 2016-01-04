defmodule Autox.ChangeSessionPlug do
  import Plug.Conn
  import Phoenix.Controller, only: [action_name: 1]
  alias Autox.SessionUtils, as: Su

  def init, do: []
  def init(_), do: []

  def call(conn, _) do
    conn |> register_before_send(&consider_change/1)
  end

  def consider_change(%{status: 200}=conn), do: change_core(conn)
  def consider_change(%{status: 201}=conn), do: change_core(conn)
  def consider_change(%{status: 204}=conn), do: change_core(conn)
  def consider_change(conn), do: conn

  defp change_core(conn) do
    case conn |> action_name do
      :create -> conn |> login
      :update -> conn |> change
      :delete -> conn |> logout
      _ -> conn
    end
  end

  defp change(conn) do
    session = conn.assigns |> Map.get(:data)
    conn |> Su.change(session)
  end

  defp login(conn) do
    session = conn.assigns |> Map.get(:data)
    conn |> Su.login(session)
  end

  defp logout(conn), do: Su.logout(conn)
end