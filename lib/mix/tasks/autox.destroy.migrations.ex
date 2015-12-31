defmodule Mix.Tasks.Autox.Destroy.Migrations do
  use Mix.Task
  alias Mix.Shell.IO
  @shortdoc """
  runs `rm -r priv/repo/migrations`
  """
  def run(_) do
    File.cwd! 
    |> Path.join("priv/repo/migrations")
    |> File.rm_rf
    |> case do
      {:ok, files} -> 
        IO.info "clobbered migrations:"
        for file <- files, do: IO.info(file)
      {:error, reason, _} ->
        IO.error "Unable to clobber migrations because: '#{reason}'"
    end
  end

end