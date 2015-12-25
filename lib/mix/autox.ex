defmodule Mix.Autox do
  alias Fox.StringExt
  def inflect(model) do
    type = case model |> StringExt.reverse_consume("Relationship") do
      {:ok, _} -> :relationship
      {:error, _} -> :conventional
    end
    name = model |> StringExt.underscore |> StringExt.pluralize
    
    [base: Mix.Phoenix.base,
    relational_type?: type == :relationship,
    model: model,
    collection_name: name]
  end

  def paths do
    ["."]
  end

  def ctrl_2_model(ctrl) do
    ctrl
    |> Module.split
    |> List.last
    |> StringExt.reverse_consume!("Controller")
  end
end