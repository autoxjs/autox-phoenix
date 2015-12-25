defmodule Autox.RelationUtils do
  import Ecto
  alias Ecto.Association.BelongsTo
  alias Ecto.Association.Has
  alias Ecto.Association.HasThrough
  alias Ecto.Association.NotLoaded
  alias Ecto.Schema
  @moduledoc """
  For reference:

  %Ecto.Association.BelongsTo{cardinality: :one, defaults: [], field: :flavor,
   owner: Apiv3.RelationshipUtilsTest.Ingredient, owner_key: :flavor_id,
   queryable: Flavor, related: Flavor, related_key: :id}

  %Ecto.Association.Has{cardinality: :many, defaults: [], field: :shops_flavors,
   on_cast: :changeset, on_delete: :nothing, on_replace: :raise,
   owner: Apiv3.RelationshipUtilsTest.Flavor, owner_key: :id,
   queryable: ShopFlavor, related: ShopFlavor, related_key: :flavor_id}

  %Ecto.Association.HasThrough{cardinality: :many, field: :shops,
   owner: Apiv3.RelationshipUtilsTest.Flavor, owner_key: :id,
   through: [:shops_flavors, :shop]}

  %Ecto.Association.Has{cardinality: :many, defaults: [], field: :pictures,
   on_cast: :changeset, on_delete: :nothing, on_replace: :raise,
   owner: Apiv3.RelationshipUtilsTest.Shop, owner_key: :id,
   queryable: {"shops_pictures", Apiv3.Picture}, related: Apiv3.Picture,
   related_key: :shop_id}
  """
  @spec create_relationship_changeset(Schema.t, atom, Schema.t) :: Changeset.t
  def create_relationship_changeset(apple, field, %{id: id}=orange) when not is_nil(id) do
    case apple |> reflect_association(field) |> check_legality(orange) do
      %BelongsTo{owner_key: foreign_key, related_key: references} ->
        ensure_belongs_to(apple, orange, foreign_key, references)
      %Has{owner_key: foreign_key, related_key: references} ->
        ensure_belongs_to(orange, apple, foreign_key, references)
      %HasThrough{cardinality: :one, through: [relation_key, field]} ->
        apple
        |> Map.get(relation_key)
        |> case do
          %NotLoaded{} -> throw "your has-through relationship wasn't fully loaded"
          nil -> apple |> create_relationship_changeset(relation_key, [{field, orange}])
          relation -> relation |> create_relationship_changeset(field, orange)
        end
      %HasThrough{cardinality: :many, through: [relation_key, field]} ->
        apple
        |> Map.get(field)
        |> case do
          %NotLoaded{} -> throw "your has-through relationship wasn't fully loaded"
          oranges when is_list(oranges) -> if orange in oranges, do: null_changeset(orange), else: throw "x"
          _ -> throw "I'm not sure how to do this"
        end
      nil -> throw "invalid relationship"
    end
  end
  def create_relationship_changeset(model, field, params) do
    case model |> reflect_association(field) do
      %Has{} -> model |> build_assoc(field) |> create_changeset(params)
      %BelongsTo{} -> throw "requires a transaction where we make the params first, then change this model"
      %HasThrough{} -> throw "same issue as above"
    end    
  end

  defp check_legality(%BelongsTo{related: module}=a, %{__struct__: module}), do: a
  defp check_legality(%Has{related: module}=a, %{__struct__: module}), do: a
  defp check_legality(%HasThrough{}=a, _), do: a
  defp check_legality(_, _), do: throw "illegal type"

  defp ensure_belongs_to(child, parent, foreign_key, references) do
    case {child |> Map.get(foreign_key), parent |> Map.get(references) } do
      {id, id} when not is_nil(id) -> null_changeset(child)
      {_, nil} -> throw "parent not persisted"
      {_, id} -> 
        params = %{} |> Map.put(Atom.to_string(foreign_key), id)
        child |> update_changeset(params) 
    end
  end

  defp null_changeset(model) do
    Ecto.Changeset.change(model, %{})
  end

  defp create_changeset(%{__struct__: module}=model, params) do
    module.create_changeset(model, params)
  end
  defp update_changeset(%{__struct__: module}=model, params) do
    module.update_changeset(model, params)
  end

  def reflect_association(%{__struct__: module}, field), do: reflect_association(module, field)
  def reflect_association(module, field) do
    case field |> maybe_to_existing_atom do
      nil -> nil
      atom ->
        module.__schema__(:association, atom)
    end
  end

  defp maybe_to_existing_atom(atom) when is_atom(atom), do: atom
  defp maybe_to_existing_atom(str) when is_binary(str) do
    try do
      str |> String.to_existing_atom
    rescue 
      ArgumentError -> nil
    end
  end
end