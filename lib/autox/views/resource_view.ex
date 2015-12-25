defmodule Autox.ResourceView do
  alias Fox.MapExt
  alias Fox.AtomExt
  alias Fox.DictExt
  alias Fox.RecordExt
  alias Ecto.Association.NotLoaded
  alias Autox.RelationUtils
  def infer_fields(view_module) do
    model_module = view_module |> AtomExt.infer_model_module 
    model_module.__schema__(:fields) |> Enum.reject(fn field -> field == :id end)
  end
  def infer_associations(view_module) do
    model_module = view_module |> AtomExt.infer_model_module
    model_module.__schema__(:associations)
  end

  def namespacify_links(output, %{namespace: ns}=meta) when is_map(output) and is_binary(ns) do
    output
    |> MapExt.present_update(:links, &namespacify_links_with(&1, meta))
    |> MapExt.present_update(:data, &namespacify_links(&1, meta))
    |> MapExt.present_update(:relationships, &namespacify_relationships(&1, meta))
  end
  def namespacify_links(output, _), do: output

  def namespacify_relationships(relations_map, meta) do
    relations_map |> MapExt.value_map(&namespacify_links(&1, meta))
  end

  defp namespacify_links_with(links, %{namespace: ns}) do
    links |> MapExt.present_update(:self, &Path.join(ns, &1))
  end

  def infer_links(model) do
    %{id: id, type: type} = model 
    |> resource_identifier

    self_link = [type, id]
    |> Enum.map(&to_string/1)
    |> Path.join
    
    %{self: self_link}
  end
  def infer_links(%NotLoaded{__field__: field}, model) do
    model
    |> infer_links
    |> MapExt.present_update(:self, &Path.join(&1, "relationships/#{field}"))
  end
  def infer_links([model|_]=models, parent) when is_list(models) when is_map(model) do
    field = model
    |> RecordExt.infer_collection_key
    |> Atom.to_string

    parent
    |> infer_links
    |> MapExt.present_update(:self, &Path.join(&1, "relationships/#{field}"))
  end
  def infer_links(model, parent) when is_map(model) do
    field = model
    |> RecordExt.infer_model_key
    |> Atom.to_string

    parent
    |> infer_links
    |> MapExt.present_update(:self, &Path.join(&1, "relationships/#{field}"))
  end
  def infer_links(_, _), do: nil

  def jsonapify(model, attributes, relationships) do
    resource_identifier(model)
    |> MapExt.present_put(:attributes, extract_attributes(model, attributes))
    |> MapExt.present_put(:relationships, extract_relationships(model, relationships))
    |> MapExt.present_put(:links, infer_links(model))
  end

  def resource_identifier(model) do
    type = model
    |> RecordExt.infer_collection_key
    |> Atom.to_string
    %{id: model.id,
      type: type}
  end

  def extract_relationships(model, relationships) do
    model
    |> Map.take(relationships)
    |> MapExt.value_map(&render_association(&1, model))
  end

  def render_association(association, model) do
    %{}
    |> MapExt.present_put(:data, render_association_core(association, model))
    |> MapExt.present_put(:links, infer_links(association, model))
  end

  def render_association_core(%NotLoaded{__field__: field}, model) do
    case RelationUtils.reflect_association(model, field) do
      %{owner_key: id_key, related: typeclass} ->
        id = Map.get(model, id_key)
        type = AtomExt.infer_collection_key(typeclass)
        if id && type, do: %{id: id, type: type}, else: nil
      %{cardinality: :many} -> []
      _ -> nil
    end
  end
  def render_association_core(model, _) when is_map(model) do
    resource_identifier(model)
  end
  def render_association_core(models, _) when is_list(models) do
    models |> Enum.map(&resource_identifier/1)
  end
  def render_association_core(_, _), do: nil

  def extract_attributes(model, attributes) do
    model
    |> Map.take(attributes)
    |> DictExt.reject_blank_keys
  end

  defmacro __using__(_opts) do
    quote location: :keep do
      alias Autox.ResourceView
      @attributes Module.get_attribute(__MODULE__, :attributes)
      @relationships Module.get_attribute(__MODULE__, :relationships)
      def attributes, do: @attributes || ResourceView.infer_fields(__MODULE__)
      def relationships, do: @relationships || ResourceView.infer_associations(__MODULE__)

      def render("show.json", %{data: model, meta: meta}) do
        %{meta: meta}
        |> Map.put(:data, render_one(model, __MODULE__, "data.json", as: :model))
        |> ResourceView.namespacify_links(meta)
      end

      def render("index.json", %{data: models, meta: meta}) do
        %{meta: meta}
        |> Map.put(:links, render_one(meta, __MODULE__, "links.json", as: :meta))
        |> Map.put(:data, render_many(models, __MODULE__, "data.json", as: :model))
        |> ResourceView.namespacify_links(meta)
      end
      
      def render("data.json", %{model: model}) do
        model |> ResourceView.jsonapify(attributes, relationships)
      end

      def render("links.json", %{meta: meta}) do
        %{self: meta.collection_link}
      end

      defoverridable [attributes: 0, relationships: 0]
    end
  end
end