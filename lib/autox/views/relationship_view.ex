defmodule Autox.RelationshipView do
  alias Fox.RecordExt
  alias Fox.StringExt
  def resource_identifier(model) do
    type = model
    |> RecordExt.infer_collection_key
    |> Atom.to_string
    |> StringExt.dasherize
    %{id: model.id,
      type: type}
  end
  def resource_identifiers(models) do
    models |> Enum.map(&resource_identifier/1)
  end
  defmacro __using__(_opts) do
    quote location: :keep do
      alias Autox.RelationshipView
      def render("show.json", %{data: model, links: links}) do
        %{data: RelationshipView.resource_identifier(model), links: links}
      end

      def render("index.json", %{data: models, links: links}) do
        %{data: RelationshipView.resource_identifiers(models), links: links}
      end
    end
  end
end