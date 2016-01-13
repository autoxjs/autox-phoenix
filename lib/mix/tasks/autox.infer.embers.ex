defmodule Mix.Tasks.Autox.Infer.Embers do
  alias Mix.Tasks.Autox.Infer.Views
  alias Mix.Tasks.Autox.Infer.Channels
  alias Fox.StringExt
  alias Fox.DictExt
  use Mix.Task
  @shortdoc "Scaffolds ember models, services, serializers, and adapters"
  def run(args) do
    Mix.Task.run "compile", []
    switches = [test: :boolean, setup: :boolean]
    {test, setup} = case OptionParser.parse(args, switches: switches) do
      {parsed, _, _} -> {parsed[:test], parsed[:setup]}
      {_, _, _} -> {false, false}
    end
    if setup do
      setup(test)
    else
      Mix.Phoenix.base
      |> Module.concat("Router")
      |> apply(:__routes__, [])
      |> Enum.map(&Views.parent_ids/1)
      |> Enum.reduce(%{}, &view_class_associations/2)
      |> Enum.map(&scaffold(test, &1))
      scaffold_channels(test)
    end
  end

  defp scaffold_channels(test) do
    Mix.Phoenix.base
    |> Module.safe_concat("Session")
    |> Mix.Tasks.Autox.Infer.Channels.infer_belongs_to
    |> Enum.map(&scaffold_chan(&1, test))
  end

  defp scaffold_chan(%{field: field}, test) do
    destination = if(test, do: "tests/dummy/", else: "")
    paths = Mix.Autox.paths

    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.embers", "", [], [
      {:eex, "channel.coffee", destination <> "app/services/#{field}-chan.coffee"}
    ]
  end

  defp setup(test) do
    destination = if(test, do: "tests/dummy/", else: "")
    paths = Mix.Autox.paths
    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.embers", "", [], [
      {:eex, "relationship.coffee", destination <> "app/models/relationship.coffee" },
      {:eex, "serializer.coffee", destination <> "app/serializers/relationship.coffee" }
    ]

    ["session", "relationship", "application"]
    |> Enum.map(&setup_adapter(destination, &1))
  end

  defp setup_adapter(destination, model) do
    paths = Mix.Autox.paths
    binding = [model: model, class: StringExt.camelize(model)]
    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.embers", "", binding, [
      {:eex, "adapter.coffee", destination <> "app/adapters/#{model}.coffee" }
    ]
  end
  defp scaffold(test, {"sessions", _}) do
    {session, view} = "sessions" |> model_view_class_from_key 
    
    attributes = infer_attributes({session, view})
    relationships = session
    |> Channels.infer_belongs_to
    |> Enum.map(fn %{field: field, related: related} -> 
      {jkey(field), "belongsTo", Channels.related_to_string(related) |> StringExt.dasherize} end)
    paths = Mix.Autox.paths
    binding = [attrs: attributes, assocs: relationships]
    destination = if(test, do: "tests/dummy/", else: "")
    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.embers", "", binding, [
      {:eex, "session.coffee", destination <> "app/models/session.coffee"}
    ]
  end
  defp scaffold(test, {key, assocs}) do
    attributes = key 
    |> model_view_class_from_key 
    |> infer_attributes

    relationships = assocs
    |> DictExt.value_map(&jrelate/1)
    |> DictExt.reject_blank_keys
    |> Enum.map(fn {key, card} -> {jkey(key), card, model_name_from_key(key)} end)

    binding = [attrs: attributes] ++ [assocs: relationships]

    model = key |> model_name_from_key

    paths = Mix.Autox.paths
    destination = if(test, do: "tests/dummy/", else: "")

    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.embers", "", binding, [
      {:eex, "model.coffee", destination <> "app/models/#{model}.coffee"}
    ]
  end

  def model_name_from_key(key), do: key |> StringExt.singularize |> StringExt.dasherize

  defp jrelate(:index), do: "hasMany"
  defp jrelate(:show), do: "belongsTo"
  defp jrelate(_), do: nil

  def view_class_associations(%{path: path, opts: opts}, map) do
    case path |> String.split("/") |> Enum.take(5) do
      [_api, collection, ":id", "relationships", field] ->
        map |> Map.update(collection, %{}, &Map.put_new(&1, field, opts))
      [_api, collection, ":id", field] ->
        map |> Map.update(collection, %{}, &Map.put_new(&1, field, opts))
      [_api, collection, ":id"] ->
        map |> Map.put_new(collection, %{})
      [_api, collection] ->
        map |> Map.put_new(collection, %{})
      _ -> map
    end
  end

  def model_view_class_from_key(name) do
    model_name = name
    |> StringExt.underscore
    |> StringExt.singularize
    |> StringExt.camelize
    view_name = model_name <> "View"
    model_class = Mix.Phoenix.base |> Module.safe_concat(model_name)
    view_class = Mix.Phoenix.base |> Module.safe_concat(view_name)
    {model_class, view_class}
  end

  defp infer_attributes({model_class, view_class}) do
    view_class.attributes
    |> Enum.map(&typify(model_class, &1))
    |> Enum.filter(&ok_types/1)
    |> Enum.into(%{})
    |> DictExt.value_map(&jtype/1)
    |> DictExt.key_map(&jkey/1)
  end

  defp typify(model_class, field), do: {field, model_class.__schema__(:type, field)}

  defp ok_types({_, :id}), do: false
  defp ok_types(_), do: true

  defp jkey(key), do: key |> to_string |> StringExt.camelize |> dumb_lowercase
  defp dumb_lowercase(""), do: ""
  defp dumb_lowercase(str) when is_binary(str) do
    {s, tr} = str |> String.next_grapheme
    String.downcase(s) <> tr
  end
  defp jtype(:decimal), do: "number"
  defp jtype(:integer), do: "number"
  defp jtype(nil), do: "string"
  defp jtype(atom) do
    atom
    |> Atom.to_string 
    |> String.starts_with?("Elixir")
    |> if do: "moment", else: to_string(atom)
  end
end