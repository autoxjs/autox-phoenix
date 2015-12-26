defmodule Mix.Tasks.Autox.Infer.Embers do
  alias Fox.StringExt
  alias Fox.DictExt
  use Mix.Task
  @shortdoc """
  Scaffolds ember models
  """
  def run(_) do
    Mix.Phoenix.base
    |> Module.concat("Router")
    |> apply(:__routes__, [])
    |> Enum.reduce(%{}, &view_class_associations/2)
    |> Enum.map(&scaffold/1)
  end

  defp scaffold({key, assocs}) do
    attributes = key 
    |> model_view_class_from_key 
    |> infer_attributes

    relationships = assocs 
    |> DictExt.value_map(&jrelate/1)
    |> Enum.map(fn {key, card} -> {jkey(key), card, model_name_from_key(key)} end)

    binding = [attrs: attributes] ++ [assocs: relationships]

    model = key |> model_name_from_key

    paths = Mix.Autox.paths
    Mix.Phoenix.copy_from paths, "priv/templates/autox.infer.embers", "", binding, [
      {:eex, "model.coffee", "app/models/#{model}.coffee"}
    ]
  end

  defp model_name_from_key(key), do: key |> StringExt.singularize |> StringExt.dasherize

  defp jrelate(:index), do: "hasMany"
  defp jrelate(:show), do: "belongsTo"

  defp view_class_associations(%{path: path, opts: opts}, map) do
    case path |> String.split("/") |> Enum.reverse |> Enum.take(4) do
      [field, "relationships", _, parent_name] ->
        map |> Map.update(parent_name, %{}, &Map.put_new(&1, field, opts))
      [":id", model_name|_] ->
        map |> Map.put_new(model_name, %{})
      [model_name|_] ->
        map |> Map.put_new(model_name, %{})
    end
  end

  defp model_view_class_from_key(name) do
    model_name = name 
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
  defp jtype(atom) do
    atom
    |> Atom.to_string 
    |> String.starts_with?("Elixir")
    |> if do: "moment", else: to_string(atom)
  end
end