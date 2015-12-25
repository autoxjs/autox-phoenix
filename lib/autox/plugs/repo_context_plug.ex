defmodule Autox.RepoContextPlug do
  alias Autox.ContextUtils

  def init(repo), do: repo
  
  def call(conn, repo) do
    conn |> ContextUtils.put(:repo, repo)
  end
end