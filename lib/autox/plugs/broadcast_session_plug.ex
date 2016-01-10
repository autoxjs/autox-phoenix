defmodule Autox.BroadcastSessionPlug do
  import Plug.Conn
  import Phoenix.Controller, only: [action_name: 1, view_module: 1]
  import Autox.SessionUtils, only: [current_session: 1]
  alias Autox.AnnounceUtils, as: Au
  def init([]), do: {:user, __MODULE__, :ok?}
  def init(key) when is_atom(key), do: {key, __MODULE__, :ok?}
  def init([key: key, class: class, check: check]), do: {key, class, check}

  def call(conn, {target, module, check}) do
    broadcast? = &apply(module, check, [&1])
    conn |> register_before_send(&consider_broadcast(&1, broadcast?, target))
  end

  def ok?(%{status: status}) when status in [200, 201, 204], do: true
  def ok?(_), do: false

  defp consider_broadcast(conn, f, target) do
    if f.(conn) do
      conn |> do_broadcast(target)
    else
      conn
    end
  end
  defp do_broadcast(conn, nil), do: conn
  defp do_broadcast(conn, target) do
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