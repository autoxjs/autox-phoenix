defmodule Autox.ModelUtils do
  
  def has_one_throughs(class) do
    class
    |> relationships
    |> Enum.filter(&singular?/1)
    |> Enum.filter(&through?/1)
  end

  def relationships(class) do
    class.__schema__(:associations)
    |> Enum.map(&class.__schema__(:association, &1))
  end

  def through?(%{through: _}), do: true
  def through?(_), do: false

  def singular?(%{cardinality: :one}), do: true
  def singular(_), do: false
end