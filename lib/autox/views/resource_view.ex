defmodule Autox.ResourceView do
  alias Fox.MapExt
  alias Fox.StringExt
  alias Fox.AtomExt
  alias Fox.DictExt
  alias Fox.RecordExt
  alias Ecto.Association.NotLoaded
  alias Ecto.Association.BelongsTo
  alias Autox.RelationUtils
  
  def resource_identifier(model) do
    type = RecordExt.infer_collection_key(model)
    id = model.id
    %{type: type, id: id}
  end
  def infer_fields(view_module) do
    model_module = view_module |> AtomExt.infer_model_module 
    model_module
    |> struct
    |> Map.keys
    |> Enum.reject(&meta_field?/1)
    |> Enum.reject(&relation_field?(model_module, &1))
  end

  defp meta_field?(field) when field in [:__meta__, :__struct__, :id], do: true
  defp meta_field?(_), do: false

  defp relation_field?(module, field) do
    case {module.__schema__(:association, field), module.__schema__(:type, field)} do
      {nil, nil} -> false # virtual field
      {nil, :id} -> true  # belongs_to relation leftover
      {nil,   _} -> false  # valid attribute
      {_  ,   _} -> true  # other relation
    end
  end

  def infer_associations(view_module) do
    model_module = view_module |> AtomExt.infer_model_module
    model_module.__schema__(:associations)
  end

  defp post_modify_links(links, field) do
    links
    |> MapExt.present_update(:self, &Path.join(&1, "relationships/#{field}"))
    |> MapExt.present_update(:related, &Path.join(&1, "#{field}"))
  end
  def infer_links(model) do
    %{id: id, type: type} = model 
    |> resource_identifier

    self_link = [type, id]
    |> Enum.map(&to_string/1)
    |> Path.join
    
    %{self: self_link, related: self_link}
  end
  def infer_links(%NotLoaded{__field__: field}, model) do
    model
    |> infer_links
    |> post_modify_links(field)
  end
  def infer_links([model|_]=models, parent) when is_list(models) when is_map(model) do
    field = model
    |> RecordExt.infer_collection_key
    |> Atom.to_string

    parent
    |> infer_links
    |> post_modify_links(field)
  end
  def infer_links(model, parent) when is_map(model) do
    field = model
    |> RecordExt.infer_model_key
    |> Atom.to_string

    parent
    |> infer_links
    |> post_modify_links(field)
  end
  def infer_links(_, _), do: nil

  def jsonapify(model, attributes, relationships) do
    resource_identifier(model)
    |> MapExt.present_put(:attributes, extract_attributes(model, attributes))
    |> MapExt.present_put(:relationships, extract_relationships(model, relationships))
    |> MapExt.present_put(:links, infer_links(model))
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
      %BelongsTo{owner_key: id_key, related: typeclass} ->
        id = Map.get(model, id_key)
        type = AtomExt.infer_collection_key(typeclass) |> Atom.to_string |> StringExt.dasherize
        if id && type, do: %{id: id, type: type}, else: nil
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
      alias Autox.NamespaceUtils
      alias Autox.ChangesetView, as: Cv

      @attributes Module.get_attribute(__MODULE__, :attributes)
      def attributes do 
        @attributes || ResourceView.infer_fields(__MODULE__)
      end
      @relationships Module.get_attribute(__MODULE__, :relationships)
      def relationships do 
        @relationships || ResourceView.infer_associations(__MODULE__)
      end

      def render("show.json", %{data: model, meta: meta}) do
        %{meta: meta}
        |> Map.put(:links, render_one(meta, __MODULE__, "links.json", as: :meta))
        |> Map.put(:data, render_one(model, __MODULE__, "data.json", as: :model))
        |> NamespaceUtils.namespacify_links(meta)
      end

      def render("index.json", %{data: models, meta: meta}) do
        %{meta: meta}
        |> Map.put(:links, render_one(meta, __MODULE__, "links.json", as: :meta))
        |> Map.put(:data, render_many(models, __MODULE__, "data.json", as: :model))
        |> NamespaceUtils.namespacify_links(meta)
      end

      def render("error.json", %{changeset: changeset}), do: Cv.render("error.json", %{changeset: changeset})
      
      def render("data.json", %{model: model}) do
        model |> ResourceView.jsonapify(attributes, relationships)
      end

      def render("links.json", %{meta: meta}) do
        %{self: meta.resource_path}
      end

      defoverridable [attributes: 0, relationships: 0]
    end
  end
end