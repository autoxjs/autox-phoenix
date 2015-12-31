defmodule Autox.ChangesetUtils do
  defmodule MissingTypeError do
    defexception [:message]
  end
  alias Ecto.Association.BelongsTo
  alias Autox.RelationUtils
  alias Fox.StringExt
  @moduledoc """
  Changeset Utility functions for creating changesets from JSONAPI data

  consult the specs here: http://jsonapi.org/
  """

  @doc """
  From the specs site, JSONAPI POST PATCH data looks like the following:

  {
    "data": {
      "type": "photos",
      "attributes": {
        "title": "Ember Hamster",
        "src": "http://example.com/images/productivity.png"
      },
      "relationships": {
        "photographer": {
          "data": { "type": "people", "id": "9" }
        }
      }
    }
  }
  however, changesets are created from active-model-like paramters
  so this functions "flattens" out the post requests
  """
  def activemodel_paramify(%{"data" => data}), do: activemodel_paramify(data)
  def activemodel_paramify(%{"type" => type}=data) do
    module = model_module_from_collection_name type
    
    data
    |> activemodelify_attributes
    |> Map.merge data
    |> activemodelify_relationships(module)
  end

  def activemodel_paramify(_), do: nil

  def activemodelify_attributes(%{"attributes" => attrs}) when is_map(attrs) do
    attrs
  end
  def activemodelify_attributes(_), do: %{}

  def activemodelify_relationships(%{"relationships" => rels}, module) when is_map(rels) do
    rels
    |> Enum.map(&foreign_key_pair(module, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.into(%{})
  end
  def activemodelify_relationships(_, _), do: %{}

  def foreign_key_pair(module, {association, %{"data" => nil}}) do
    case RelationUtils.reflect_association(module, association) do
      %BelongsTo{owner_key: name} -> {to_string(name), nil}
      _ -> nil
    end
  end
  def foreign_key_pair(module, {association, %{"data" => %{"id" => id}}}) do
    case RelationUtils.reflect_association(module, association) do
      %BelongsTo{owner_key: name} -> {to_string(name), id}
      _ -> nil
    end
  end
  def foreign_key_pair(module, {association, %{model: %{id: id}}}) do
    case RelationUtils.reflect_association(module, association) do
      %BelongsTo{owner_key: name} -> {to_string(name), id}
      _ -> nil
    end
  end
  def foreign_key_pair(_, _), do: nil

  def model_module_from_collection_name(nil) do
    raise MissingTypeError,
      message: "I expect all post data to create to contain a 'type' parameter, but you didn't provide one"
  end
  def model_module_from_collection_name(atom) when is_atom(atom) do
    RelationUtils.maybe_to_existing_model(atom)
  end
  def model_module_from_collection_name(type) when is_binary(type) do 
    name = type |> StringExt.singularize |> StringExt.camelize
    Mix.Phoenix.base |> Module.safe_concat(name)
  end

end