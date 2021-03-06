defmodule Autox.AnnounceUtils do
  alias Fox.RecordExt
  alias Autox.ResourceView, as: Rv
  @endpoint Autox.default_endpoint
  @levels ~w(info success warning alert error)
  def notify(target, level, message) when level in @levels do
    topic = infer_topic(target)
    @endpoint.broadcast topic, "notify", %{level: level, message: message}
  end

  def refresh(model, target) do
    data = Rv.resource_identifier(model)
    target |> infer_topic |> @endpoint.broadcast("refresh", data)
  end

  def destroy(%{data: model}=pack, view_class, target) do
    data = view_class.render("show.json", pack)
    target |> infer_topic |> @endpoint.broadcast("destroy", data)
    model
  end

  def update(%{data: model}=pack, view_class, target) do
    data = view_class.render("show.json", pack)
    target |> infer_topic |> @endpoint.broadcast("update", data)
    model
  end

  defp infer_subtopic(model) do
    model
    |> RecordExt.infer_collection_key
    |> Atom.to_string
  end

  defp infer_topic(%{id: id}=model) do
    model |> infer_subtopic |> Kernel.<>(":#{id}")
  end
end