defmodule Autox.AnnounceUtils do
  alias Fox.RecordExt
  @endpoint Autox.default_endpoint
  @levels ~w(info success warning alert error)
  def notify(target, level, message) when level in @levels do
    topic = infer_topic(target)
    @endpoint.broadcast topic, "notify", %{level: level, message: message}
  end

  def destroy(%{data: model}=pack, view_class, target) do
    data = view_class.render("show.json", pack)
    target |> infer_topic(model) |> @endpoint.broadcast("destroy", data)
    model
  end

  def update(%{data: model}=pack, view_class, target) do
    data = view_class.render("show.json", pack)
    target |> infer_topic(model) |> @endpoint.broadcast("update", data)
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

  defp infer_topic(parent, child) do
    [infer_topic(parent), infer_subtopic(child)] |> Enum.join(":")
  end
end