defmodule Autox.RepoTransformPlug do
  alias Autox.ContextUtils

  def init(transform), do: transform
  
  def call(conn, transform) do
    conn |> ContextUtils.update(:repo, &transform.new/1)
  end  
end