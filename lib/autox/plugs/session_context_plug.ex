defmodule Autox.SessionContextPlug do
  alias Autox.ContextUtils, as: Cu
  alias Autox.SessionUtils, as: Su
  @moduledoc """
  Takes something out of the current session and moves into the context
  """
  def init([]), do: {:user, :parent}
  def init([session: skey, context: ckey]), do: {skey, ckey}

  def call(conn, {skey, ckey}) do
    x = conn |> Su.current_session |> Map.get(skey)
    conn |> Cu.put(ckey, x)
  end
end