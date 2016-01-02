defmodule Autox.RelationUtils do
  import Ecto
  alias Ecto.Association.BelongsTo
  alias Ecto.Association.Has
  alias Ecto.Association.HasThrough
  alias Autox.ChangesetUtils
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
  def caac(r, p, k, d), do: creative_action_and_changeset(r,p,k,d)
  def creative_action_and_changeset(repo, parent, key, data) do
    data
    |> find_class
    |> find_or_create_model(repo, data)
    |> case do
      {:ok, data} -> create_core(repo, parent, key, data)
      other -> other
    end
  end

  def find_class(data), do: data |> Map.get("type") |> maybe_to_existing_model

  defp find_or_create_model(nil, _, _), do: {:error, "no such type"}
  defp find_or_create_model(class, repo, %{"id" => id}=data) do
    case repo.get(class, id) do
      nil -> {:error, "no such model #{id}"}
      model -> 
        data = data
        |> Map.drop(["id"])
        |> Map.put(:model, model)
        {:ok, data}
    end
  end
  defp find_or_create_model(_, _, data), do: {:ok, data}

  defp create_core(repo, parent, key, data) do
    parent 
    |> reflect_association(key)
    |> case do
      %{cardinality: :one}=relation ->
        parent 
        |> repo.preload([key])
        |> singular_cardinality_check(key, data, &create1(&1, relation, &2))
      %{cardinality: :many}=relation ->
        checker = &repo.get(assoc(parent, key), &1)
        worker = &createx(parent, relation, &1)
        plural_cardinality_check(checker, data, worker)
    end
  end

  def createx(parent, %Has{}=r, data), do: create1(parent, r, data)

  def createx(parent, %HasThrough{through: [near_field, far_field]}, data) do
    parent 
    |> reflect_association(near_field)
    |> double_reflect_association(far_field)
    |> through
    |> apply([parent, data])
  end

  defp many_many_through(_, _), do: {:error, "refuse to create many-many through relationship due"}
  defp one_many_through(near_relation, far_relation, parent, data) do
    %{field: near_field, related: class, owner_key: pkey, related_key: fkey} = near_relation
    %{field: far_field} = far_relation
    attributes = data 
    |> Map.get("attributes", %{})
    |> Map.put(to_string(fkey), Map.get(parent, pkey))
    relationships = %{} |> Map.put(to_string(far_field), data)
    params = %{"type" => class, "attributes" => attributes, "relationships" => relationships}

    case parent |> Map.get(near_field) do
      nil -> create1(parent, near_relation, params)
      parent -> create1(parent, far_relation, params)
    end
  end
  defp many_one_through(near_relation, far_relation, parent, data) do
    %{field: near_field, related: class, owner_key: pkey, related_key: fkey} = near_relation
    %{field: far_field} = far_relation
    attributes = data 
    |> Map.get("attributes", %{})
    |> Map.put(to_string(fkey), Map.get(parent, pkey))
    relationships = %{} |> Map.put(to_string(far_field), data)
    params = %{"type" => class, "attributes" => attributes, "relationships" => relationships}

    case data |> Map.get(:model) do
      nil -> {:error, "many through one with a nonexistent one isn't allowed"}
      _ -> create1(parent, near_relation, params)
    end
  end
  def one_one_through(a,b,c,d), do: one_many_through(a,b,c,d)

  defp through({%{cardinality: :many}, %{cardinality: :many}}), do: &many_many_through/2
  defp through({%{cardinality: :many}=rn, %{cardinality: :one}=rf}), do: &many_one_through(rn, rf, &1, &2)
  defp through({%{cardinality: :one}=rn, %{cardinality: :many}=rf}), do: &one_many_through(rn, rf, &1, &2)
  defp through({%{cardinality: :one}=rn, %{cardinality: :one}=rf}), do: &one_one_through(rn, rf, &1, &2)

  defp create1(parent, %HasThrough{}=r, data), do: createx(parent, r, data)
  
  defp create1(parent, %BelongsTo{owner_key: key, owner: class}, %{model: child}) do
    params = %{} |> Map.put(key, child.id)
    cs = parent |> class.update_changeset(params)
    {:update, cs}
  end
  defp create1(_, %BelongsTo{}, data) do
    {:error, "refuse to create belongs_to relationships in reverse"}
  end

  defp create1(parent, %Has{related_key: key, related: class}, %{model: child}) do
    params = %{} |> Map.put(key, parent.id)
    cs = child |> class.update_changeset(params)
    {:update, cs}
  end
  defp create1(parent, %Has{related: class, field: field}, data) do
    params = ChangesetUtils.activemodel_paramify(data)
    cs = parent 
    |> build_assoc(field)
    |> class.create_changeset(params)
    {:insert, cs}
  end

  defp singular_cardinality_check(parent, field, model, f) do
    id = model |> Map.get(:model, %{}) |> Map.get(:id)
    parent
    |> Map.get(field)
    |> case do
      %{id: ^id} when not is_nil(id) -> {:ok, model}
      %{id: id} -> {:error, "already occupied by '#{id}'"}
      nil -> f.(parent, model)
    end
  end

  defp plural_cardinality_check(checker, %{model: %{id: id}}=d, f) do
    case checker.(id) do
      nil -> f.(d)
      model -> {:ok, model}
    end
  end
  defp plural_cardinality_check(_, data, f), do: f.(data)

  def reflect_association(%{__struct__: module}, field), do: reflect_association(module, field)
  def reflect_association(module, field) do
    case field |> maybe_to_existing_atom do
      nil -> nil
      atom ->
        module.__schema__(:association, atom)
    end
  end

  def double_reflect_association(%{related: module}=r, field), do: {r, reflect_association(module, field)}
  def double_reflect_association(r, _), do: {r, nil}

  def maybe_to_existing_model(atom) when is_atom(atom) do
    atom 
    |> Atom.to_string 
    |> case do
      "Elixir." <> _ -> atom
      symbol -> symbol |> maybe_to_existing_model
    end
  end
  def maybe_to_existing_model(str) when is_binary(str) do
    try do
      ChangesetUtils.model_module_from_collection_name(str)
    rescue
      ArgumentError -> nil
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