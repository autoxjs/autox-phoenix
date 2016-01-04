defmodule Mix.Tasks.Autox.Infer.All do
  use Mix.Task
  alias Mix.Tasks.Autox.Infer.Views
  alias Mix.Tasks.Autox.Infer.Models
  alias Mix.Tasks.Autox.Infer.Controllers
  @shortdoc "Scaffolds controllers, views, and models"
  def run(args) do
    Mix.Task.run "compile", []
    Models.run(args)
    Views.run(args)
    Controllers.run(args)
  end

end