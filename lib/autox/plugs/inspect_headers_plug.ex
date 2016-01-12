defmodule Autox.InspectHeadersPlug do
  import Plug.Conn
  def init, do: []
  def init(_), do: []

  def call(conn, base) do
    conn |> inspect_conn |> register_before_send(&inspect_conn/1)
  end

  defp inspect_conn(conn) do
    IO.inspect conn
    conn
  end
end