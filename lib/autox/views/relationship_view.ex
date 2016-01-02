defmodule Autox.RelationshipView do
  alias Fox.RecordExt
  alias Fox.StringExt
  alias Autox.ResourceView

  defmacro __using__(_opts) do
    quote location: :keep do
      alias Autox.RelationshipView
      alias Autox.NamespaceUtils
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

      def render("data.json", %{model: model}) do
        model
        |> RecordExt.view_for_model
        |> apply(:render, ["data.json", %{model: model}])
      end
      def render("links.json", %{meta: meta}) do
        %{self: meta.resource_path}
      end
    end
  end
end