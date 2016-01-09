defmodule Mix.Tasks.Autox.Infer.Models do
  alias Fox.StringExt
  use Mix.Task
  @shortdoc "Scaffolds models after inferring from the `router.ex` file"
  def run(_) do
    Mix.Task.run "compile", []
    Mix.Phoenix.base
    |> Module.concat("Router")
    |> apply(:__routes__, [])
    |> Enum.map(&Map.get(&1, :plug))
    |> Enum.uniq
    |> Enum.map(&Mix.Autox.ctrl_2_model/1)
    |> Enum.map(&scaffold/1)
  end

  def scaffold("Session") do
    binding = [base: Mix.Phoenix.base]
    paths = Mix.Autox.paths
    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.models", "", binding, [
      {:eex, "session.ex", "web/models/session.ex"}
    ]
  end
  def scaffold("User") do
    binding = [base: Mix.Phoenix.base]
    paths = Mix.Autox.paths
    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.models", "", binding, [
      {:eex, "user.ex", "web/models/user.ex"}
    ]
  end
  def scaffold(model) do
    binding = Mix.Autox.inflect(model)
    model = binding[:model] |> StringExt.underscore
    paths = Mix.Autox.paths
    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.models", "", binding, [
      {:eex, "model.ex", "web/models/#{model}.ex"}
    ]
  end

end