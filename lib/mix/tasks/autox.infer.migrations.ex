defmodule Mix.Tasks.Autox.Infer.Migrations do
  alias Fox.StringExt
  alias Fox.AtomExt
  alias Ecto.Association.BelongsTo
  use Mix.Task
  @shortdoc "Attempts to write migrations for all the files in the `web/models` folder"
  def run(_) do
    Mix.Task.run "compile", []

    migration_cores = models_dir |> File.ls! |> Enum.map(&infer_model_plural_class/1)
    concrete_cores = migration_cores |> Enum.filter(&concrete_tables?/1)
    polymorph_cores = migration_cores |> Enum.map(&elem(&1, 2)) |> Enum.flat_map(&polymorphic_plural_class/1)

    creates = (concrete_cores ++ polymorph_cores)
    |> Enum.map(&create_table_migration/1)
    |> Enum.sort_by(&elem(&1, 1))
    |> Enum.reduce([], &merge_sources/2)
    
    alters = (concrete_cores ++ polymorph_cores)
    |> Enum.map(&add_reference_migration/1)
    |> Enum.reject(&last_blank?/1)
    |> Enum.sort_by(&elem(&1, 1))
    |> Enum.reduce([], &merge_sources/2)
    
    (creates ++ alters)
    |> List.foldl(0, &run_migration/2)
  end
  defp last_blank?({_, _, []}), do: true
  defp last_blank?(_), do: false

  defp merge_sources({model, source, attrs}, [{_, source, attrs2}|tuples]) do
    tuple = {model, source, Enum.uniq(attrs ++ attrs2)}
    [tuple|tuples]
  end
  defp merge_sources(tuple, tuples), do: [tuple|tuples]

  def run_migration({class, plural, attrs}, n) do
    Mix.Tasks.Autox.Phoenix.Migration.run([n, class, plural] ++ attrs)
    n + 1
  end

  def polymorphic_plural_class(class) do
    class.__schema__(:associations)
    |> Enum.map(&class.__schema__(:association, &1))
    |> Enum.filter_map(&just_polymorphic_has?/1, &class_model_plural_from_relation/1)
  end

  def just_polymorphic_has?(%{queryable: {_, _}}), do: true
  def just_polymorphic_has?(_), do: false
  def class_model_plural_from_relation(%{queryable: {source, class}}) do
    model = class |> Module.split |> List.last
    {model, source, class}
  end

  def infer_model_plural_class(filename) do
    model = filename
    |> StringExt.reverse_consume!(".ex")
    |> StringExt.camelize
    class = Mix.Phoenix.base |> Module.safe_concat(model)
    plural = class.__schema__(:source)
    {model, plural, class}
  end

  @underscored ~r/^[a-z0-9_]+$/
  def concrete_tables?({_, table_name, _}) do
    table_name |> String.match?(@underscored)
  end

  def add_reference_migration({_, plural, class}) do
    model = plural |> StringExt.camelize
    {model, plural, infer_assocs(class)} 
  end

  def create_table_migration({_, plural, class}) do
    model = plural |> StringExt.camelize
    {model, plural, infer_types(class)} 
  end

  def models_dir do
    File.cwd! |> Path.join("web/models")
  end

  defp join(tupe, joiner\\":") when is_tuple(tupe), do: tupe |> Tuple.to_list |> Enum.join(joiner)

  defp just_belongs_to(%BelongsTo{}), do: true
  defp just_belongs_to(_), do: false

  defp stringify_assoc(%{related: related, owner_key: owner_key}) do
    reference = related
    |> AtomExt.infer_collection_key
    [owner_key, "references", reference]
    |> Enum.join(":")
  end

  defp infer_types(model) do
    model.__schema__(:types)
    |> Enum.map(&keyify_datetime/1)
    |> Enum.reject(&bad_type?/1)
    |> Enum.map(&join/1)
  end

  defp bad_type?({_, :id}), do: true
  defp bad_type?({:inserted_at, :datetime}), do: true
  defp bad_type?({:updated_at, :datetime}), do: true
  defp bad_type?(_), do: false

  defp infer_assocs(model) do
    model.__schema__(:associations)
    |> Enum.map(&model.__schema__(:association, &1))
    |> Enum.filter_map(&just_belongs_to/1, &stringify_assoc/1)
  end

  defp keyify_datetime({key, atom}) do
    atom 
    |> Atom.to_string 
    |> StringExt.consume("Elixir")
    |> case do
      {:ok, _} -> {key, :datetime}
      {:error, _} -> {key, atom}
    end
  end
end