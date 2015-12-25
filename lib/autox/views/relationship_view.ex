defmodule Autox.RelationshipView do
  alias Fox.RecordExt
  def render_identifier(model) do
    %{
      id: model.id,
      type: RecordExt.infer_collection_key(model)
    }
  end
  def render_identifiers(models) do
    models |> Enum.map(&render_identifier/1)
  end
  defmacro __using__(_opts) do
    quote location: :keep do
      alias Autox.RelationshipView
      def render("show.json", %{data: model, links: links}) do
        %{data: RelationshipView.render_identifier(model), links: links}
      end

      def render("index.json", %{data: models, links: links}) do
        %{data: RelationshipView.render_identifiers(models), links: links}
      end
    end
  end
end