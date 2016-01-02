defmodule Autox.InspectHeadersPlug do
  import Plug.Conn
  def init, do: []
  def init(_), do: []

  def call(conn, base) do
    IO.inspect conn
    conn
  end
end