defmodule Mix.Tasks.Autox.Infer.Controllers do
  alias Fox.StringExt
  use Mix.Task
  @shortdoc """
  Scaffolds controllers after inferring from the `router.ex` file
  """
  def run(_) do
    Mix.Phoenix.base
    |> Module.concat("Router")
    |> apply(:__routes__, [])
    |> Enum.map(&Map.get(&1, :plug))
    |> Enum.uniq
    |> Enum.map(&Mix.Autox.ctrl_2_model/1)
    |> Enum.map(&scaffold/1)
  end

  def scaffold(model) do
    binding = Mix.Autox.inflect(model)
    model = binding[:model] |> StringExt.underscore
    paths = Mix.Autox.paths
    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.controllers", "", binding, [
      {:eex, "controller.ex", "web/controllers/#{model}_controller.ex"}
    ]
  end
end