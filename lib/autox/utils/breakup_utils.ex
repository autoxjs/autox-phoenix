defmodule Autox.BreakupUtils do
  alias Ecto.Association.BelongsTo
  alias Ecto.Association.Has
  alias Ecto.Association.HasThrough
  alias Autox.RelationUtils, as: Ru

  def daac(a,b,c,d), do: destructive_action_and_changeset(a,b,c,d)
  def destructive_action_and_changeset(repo, parent, key, data) do
    data
    |> Ru.find_class
    |> find_or_fail_model(repo, data)
    |> case do
      {:ok, model} -> delete_core(repo, parent, key, model)
      other -> other
    end
  end

  defp find_or_fail_model(nil, _, _), do: {:error, "no such type"}
  defp find_or_fail_model(class, repo, %{"id" => id}) do
    case repo.get(class, id) do
      nil -> {:error, "no record exists"}
      model -> {:ok, model}
    end
  end

  defp delete_core(repo, parent, key, model) do
    parent = parent |> repo.preload([key])
    parent
    |> Ru.reflect_association(key)
    |> destroy(parent, model)
  end

  defp destroy(%BelongsTo{owner: class, owner_key: fkey, related_key: pkey}, parent, model) do
    case {Map.get(parent, fkey), Map.get(model, pkey)} do
      {nil, _} -> {:ok, parent}
      {id, id} ->
        params = %{} |> Map.put(fkey, nil)
        cs = parent |> class.update_changeset(params)
        {:update, cs}
      {_, _} -> {:ok, parent}
    end
  end
  defp destroy(%Has{related: class, owner_key: pkey, related_key: fkey}, parent, model) do
    case {Map.get(parent, pkey), Map.get(model, fkey)} do
      {_, nil} -> {:ok, model}
      {id, id} ->
        params = %{} |> Map.put(fkey, nil)
        cs = model |> class.update_changeset(params)
        {:update, cs}
      {_, _} -> {:ok, model}
    end
  end
  defp destroy(%HasThrough{through: [nearfield, farfield]}, parent, model) do
    parent 
    |> Ru.reflect_association(nearfield)
    |> Ru.double_reflect_association(farfield)
    |> through
    |> apply([parent, model])
  end

  defp through({%Has{}=r, _}), do: &destroy_parent_relationship(r, &1, &2)
  defp through({%BelongsTo{}=r, _}), do: &destroy(r, &1, &2)

  defp destroy_parent_relationship(%{field: field}, parent, _) do
    case parent |> Map.get(field) do
      nil -> {:ok, parent}
      [relationship] -> {:delete, relationship}
      relationship -> {:delete, relationship}
    end
  end
end