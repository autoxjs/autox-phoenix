defmodule Mix.Tasks.Autox.Destroy.Views do
  alias Fox.StringExt
  alias Mix.Tasks.Autox.Infer.Views
  use Mix.Task
  
  def run(_) do
    Mix.Task.run "compile", []
    Mix.Phoenix.base
    |> Module.safe_concat("Router")
    |> apply(:__routes__, [])
    |> Enum.map(&Views.parent_ids/1)
    |> Enum.reduce(%{}, &Views.path_associations/2)
    |> Enum.map(&destroy/1)
  end

  def destroy({controller, _}) do
    model = controller |> Mix.Autox.ctrl_2_model |> StringExt.underscore
    filename = File.cwd! |> Path.join("web/views/#{model}_view.ex")

    case File.rm(filename) do
      :ok -> Mix.shell.info [:green, "* removed file ", :reset, filename]
      {:error, _} -> Mix.shell.info [:red, "* unable to remove file", :reset, filename]
    end
  end
end