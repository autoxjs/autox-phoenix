defmodule Autox.RelationshipView do
  defmacro __using__(_opts) do
    quote location: :keep do
      alias Autox.NamespaceUtils
      alias Autox.ChangesetView, as: Cv
      alias Autox.MetaUtils, as: Mu
      alias Fox.RecordExt
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
        model
        |> RecordExt.view_for_model
        |> apply(:render, ["data.json", %{model: model}])
      end
      def render("links.json", %{meta: meta}) do
        meta |> Mu.links_hash
      end
    end
  end
end