defmodule Mix.Tasks.Autox.Infer.Channels do
  alias Fox.StringExt
  use Mix.Task
  alias Ecto.Association.BelongsTo

  @shortdoc "Reads your Session model and generates channels for every belongs_to relationship in there"
  def run(_) do
    Mix.Task.run "compile", []
    scaffold_socket
    Mix.Phoenix.base
    |> Module.safe_concat("Session")
    |> infer_belongs_to
    |> Enum.map(&scaffold_chan/1)
  end

  def scaffold_socket do
    binding = [base: Mix.Phoenix.base]
    paths = Mix.Autox.paths
    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.channels", "", binding, [
      {:eex, "user_socket.ex", "web/channels/user_socket.ex"}
    ]
  end

  def related_to_string(related), do: related |> Module.split |> List.last

  @socket_insertions """
  channel "<%= collection %>:*", <%= base %>.<%= model %>Channel
  """
  def scaffold_chan(%{field: field, related: related}) do
    collection = field |> Atom.to_string |> StringExt.pluralize
    model = related |> related_to_string
    base = Mix.Phoenix.base
    binding = [base: base, collection: collection, model: model]
    paths = Mix.Autox.paths
    model = model |> StringExt.underscore

    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.channels", "", binding, [
      {:eex, "channel.ex", "web/channels/#{model}_channel.ex"}
    ]

    ("\n\s\s" <> @socket_insertions)
    |> EEx.eval_string(binding)
    |> Mix.Autox.inject_into_file("web/channels/user_socket.ex", after: "## Channels")
  end

  def infer_belongs_to(session_module) do
    session_module.__schema__(:associations)
    |> Enum.map(&(session_module.__schema__(:association, &1)))
    |> Enum.filter(&belongs_to?/1)
  end

  defp belongs_to?(%BelongsTo{}), do: true
  defp belongs_to?(_), do: false
end