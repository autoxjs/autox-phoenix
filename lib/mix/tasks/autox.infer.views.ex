defmodule Mix.Tasks.Autox.Infer.Views do
  alias Fox.StringExt
  alias Mix.Tasks.Autox.Infer.Embers
  use Mix.Task
  @shortdoc """
  Scaffolds views after inferring from the `router.ex` file
  """
  def run(_) do
    Mix.Phoenix.base
    |> Module.concat("Router")
    |> apply(:__routes__, [])
    |> Enum.reduce(%{}, &Embers.view_class_associations/2)
    |> Enum.map(&scaffold/1)
  end

  def scaffold({key, assocs}) do
    {model_class, _} = key |> Embers.model_view_class_from_key
    binding = model_class |> Module.split |> List.last |> Mix.Autox.inflect 
    binding = binding ++ [relationships: Map.keys(assocs)]
    model = binding[:model] |> StringExt.underscore
    paths = Mix.Autox.paths
    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.views", "", binding, [
      {:eex, "view.ex", "web/views/#{model}_view.ex"}
    ]
  end

end