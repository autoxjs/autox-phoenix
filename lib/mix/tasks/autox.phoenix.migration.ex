defmodule Mix.Tasks.Autox.Phoenix.Migration do
  use Mix.Task

  @shortdoc "Generates an Ecto migration"

  @moduledoc """
  Code copy+pasted from https://github.com/phoenixframework/phoenix/blob/master/lib/mix/tasks/phoenix.gen.model.ex
  """
  def run(args) do
    switches = [migration: :boolean, binary_id: :boolean, instructions: :string]

    {opts, parsed, _} = OptionParser.parse(args, switches: switches)
    [xg, singular, plural | attrs] = validate_args!(parsed)

    default_opts = Application.get_env(:phoenix, :generators, [])
    opts = Keyword.merge(default_opts, opts)

    uniques   = Mix.Phoenix.uniques(attrs)
    attrs     = Mix.Phoenix.attrs(attrs)
    binding   = Mix.Phoenix.inflect(singular)
    params    = Mix.Phoenix.params(attrs)
    path      = binding[:path]
    migration = String.replace(path, "/", "_")
    {assocs, attrs} = partition_attrs_and_assocs(attrs)
    create? = Enum.empty?(assocs)
    binding = binding ++
              [attrs: attrs, plural: plural, types: types(attrs), uniques: uniques,
               assocs: assocs(assocs), indexes: indexes(plural, assocs, uniques),
               defaults: defaults(attrs), params: params,
               binary_id: opts[:binary_id], create?: create?]

    files = []

    if opts[:migration] != false do
      action = if create?, do: "create", else: "alter"
      files =
        [{:eex, "migration.exs", "priv/repo/migrations/#{timestamp(xg)}_#{action}_#{migration}.exs"}|files]
    end

    Mix.Phoenix.copy_from paths(), "priv/templates/autox.phoenix.migration", "", binding, files

    # Print any extra instruction given by parent generators
    Mix.shell.info opts[:instructions] || ""

    if opts[:migration] != false do
      Mix.shell.info """
      Remember to update your repository by running migrations:
          $ mix ecto.migrate
      """
    end
  end

  defp validate_args!([_, _, plural | _] = args) do
    cond do
      String.contains?(plural, ":") ->
        raise_with_help
      plural != Phoenix.Naming.underscore(plural) ->
        Mix.raise "expected the second argument, #{inspect plural}, to be all lowercase using snake_case convention"
      true ->
        args
    end
  end

  defp validate_args!(_) do
    raise_with_help
  end

  defp raise_with_help do
    Mix.raise """
    mix phoenix.gen.model expects both singular and plural names
    of the generated resource followed by any number of attributes:
        mix phoenix.gen.model User users name:string
    """
  end

  defp partition_attrs_and_assocs(attrs) do
    Enum.partition attrs, fn
      {_, {:references, _}} ->
        true
      {key, :references} ->
        Mix.raise """
        Phoenix generators expect the table to be given to #{key}:references.
        For example:
            mix phoenix.gen.model Comment comments body:text post_id:references:posts
        """
      _ ->
        false
    end
  end

  defp assocs(assocs) do
    Enum.map assocs, fn {key_id, {:references, source}} ->
      key   = String.replace(Atom.to_string(key_id), "_id", "")
      assoc = Mix.Phoenix.inflect key
      {String.to_atom(key), key_id, assoc[:module], source}
    end
  end

  defp indexes(plural, assocs, uniques) do
    Enum.concat(
      Enum.map(assocs, fn {key, _} ->
        "create index(:#{plural}, [:#{key}])"
      end),
      Enum.map(uniques, fn key ->
        "create unique_index(:#{plural}, [:#{key}])"
      end))
  end

  defp timestamp(xg\\"") do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}#{pad(xg)}"
  end

  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)

  defp types(attrs) do
    Enum.into attrs, %{}, fn
      {k, {c, v}}       -> {k, {c, value_to_type(v)}}
      {k, v}            -> {k, value_to_type(v)}
    end
  end

  defp defaults(attrs) do
    Enum.into attrs, %{}, fn
      {k, :boolean}  -> {k, ", default: false"}
      {k, _}         -> {k, ""}
    end
  end

  defp value_to_type(:text), do: :string
  defp value_to_type(:uuid), do: Ecto.UUID
  defp value_to_type(:date), do: Ecto.Date
  defp value_to_type(:time), do: Ecto.Time
  defp value_to_type(:datetime), do: Ecto.DateTime
  defp value_to_type(v) do
    if Code.ensure_loaded?(Ecto.Type) and not Ecto.Type.primitive?(v) do
      Mix.raise "Unknown type `#{v}` given to generator"
    else
      v
    end
  end

  defp paths do
    [".", :phoenix]
  end
end