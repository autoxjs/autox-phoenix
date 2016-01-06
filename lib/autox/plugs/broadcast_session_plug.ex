defmodule Autox.BroadcastSessionPlug do
  import Plug.Conn
  import Phoenix.Controller, only: [action_name: 1, view_module: 1]
  import Autox.SessionUtils, only: [current_session: 1]
  alias Autox.AnnounceUtils, as: Au
  def init([]), do: :user
  def init(key) when is_atom(key), do: key

  def call(conn, target) do
    conn |> register_before_send(&consider_broadcast(&1, target))
  end

  defp consider_broadcast(%{status: status}=conn, target) when status in [200, 201, 204] do
    case conn |> action_target(target) do
      {_, nil, _} -> nil
      {_, _, nil} -> nil
      {:create, target, view} -> Au.update(conn.assigns, view, target)
      {:update, target, view} -> Au.update(conn.assigns, view, target)
      {:delete, target, view} -> Au.destroy(conn.assigns, view, target)
      {_, _, _} -> nil
    end
    conn
  end
  defp consider_broadcast(conn, _), do: conn

  defp action_target(%{assigns: a}=conn, target) do
    target = conn |> current_session |> Map.get(target)
    view = conn |> view_module
    action = case {a[:relate], a[:unrelate]} do
      {{_, _}, _} -> :relate
      {_, {_, _}} -> :unrelate
      {_, _} -> conn |> action_name
    end
    {action, target, view}
  end
end