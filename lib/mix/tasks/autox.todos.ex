defmodule Mix.Tasks.Autox.Todos do
  use Mix.Task
  @shortdoc "Displays a list of tasks you need to do before this is ready for production"

  @todos [
    "edit prod.exs so that Autox knows the host where you're Ember frontend is served",
    "edit environment.js in the front-end Ember app for host, namespace, and CSRP",
    "edit prod.exs to infer heroku environment variables",
    "edit endpoint.ex and set a max_age to cookie sessions"
  ]
  def run(_) do
    @todos |> Enum.map(&display/1)
  end

  defp display(msg) do
    Mix.Shell.IO.info [:yellow, " * " <> msg]
  end
end