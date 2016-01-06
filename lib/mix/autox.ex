defmodule Mix.Autox do
  alias Fox.StringExt
  def inflect(atom) when is_atom(atom), do: atom |> to_string |> inflect
  def inflect(model) do
    type = case model |> StringExt.reverse_consume("Relationship") do
      {:ok, _} -> :relationship
      {:error, _} -> :conventional
    end
    name = model |> StringExt.underscore |> StringExt.pluralize
    
    [base: Mix.Phoenix.base,
    relational_type?: type == :relationship,
    model: model,
    collection_name: name]
  end

  def paths do
    [:autox]
  end

  def ctrl_2_model(ctrl) do
    ctrl
    |> Module.split
    |> List.last
    |> StringExt.reverse_consume!("Controller")
  end

  def append_to_file(string, filename) do
    file = open(filename, [:append])
    IO.puts(file, string)
    File.close(file)
    Mix.shell.info [:green, "* appending to ", :reset, filename]
  end

  def inject_into_file(string, filename, after: pattern) do
    read(filename) 
    |> String.replace(pattern, pattern <> "\n" <> string, global: false)
    |> write2(filename)
    Mix.shell.info [:green, "* injecting into ", :reset, filename]
  end

  defp write2(contents, filename) do
    File.cwd! |> Path.join(filename) |> File.write!(contents)
  end

  defp read(filename) do
    File.cwd! |> Path.join(filename) |> File.read!
  end

  defp open(filename, opts) do
    File.cwd! |> Path.join(filename) |> File.open!(opts)
  end
end