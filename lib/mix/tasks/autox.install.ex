defmodule Mix.Tasks.Autox.Install do
  use Mix.Task
  alias Fox.StringExt
  @shortdoc "Modifies your endpoint, config, and other files for setting up autox"

  def run(_) do
    edit_config_file
    edit_mix_file
    edit_router
    edit_endpoint
  end

  @config_template """
  ## Autox Installed
  config :plug, :mimes, %{"application/vnd.api+json" => ["json-api"]}
  config :autox, Autox.Defaults,
    repo: <%= base %>.Repo,
    session_header: "autox-remember-token",
    error_view: <%= base %>.ErrorView,
    user_class: <%= base %>.User,
    session_class: <%= base %>.Session
  ## End Autox
  """
  def edit_config_file do
    ("\n\n" <> @config_template)
    |> EEx.eval_string([base: Mix.Phoenix.base])
    |> append_to_file("config/config.exs")
  end

  @mix_injection """
  ## Autox Installed
  @package_version ~r/"version":\\s+"([a-zA-Z\\d\\.]+)"/
  def version do
    json = File.cwd!
    |> Path.join("package.json")
    |> File.read!
    @package_version
    |> Regex.scan(json)
    |> List.first
    |> List.last
  end
  ## End Autox
  """
  def edit_mix_file do
    ("\s\s" <> @mix_injection)
    |> String.replace("\n", "\n\s\s")
    |> inject_into_file("mix.exs", after: "use Mix.Project")

  end

  defp inject_into_file(string, filename, after: pattern) do
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

  @router_inject """
  ## Autox Installed
  import Autox.Manifest
  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug :fetch_session
    plug Autox.RepoContextPlug
    plug Autox.UnderscoreParamsPlug, "data"
  end
  ## End Autox
  """
  def edit_router do
    ("\s\s" <> @router_inject)
    |> String.replace("\n", "\n\s\s")
    |> inject_into_file("web/router.ex", after: ".Web, :router")
  end

  @endpoint_inject """
  ## Autox Installed
  plug CORSPlug,
    headers: ["Authorization", "Content-Type", "Accept", "Origin",
              "User-Agent", "DNT","Cache-Control", "X-Mx-ReqToken",
              "Keep-Alive", "X-Requested-With", "If-Modified-Since",
              "X-CSRF-Token"] ++ [Autox.default_session_header]
  ## End Autox
  """
  def edit_endpoint do
    base = Mix.Phoenix.base
    |> StringExt.underscore
    ("\s\s" <> @endpoint_inject)
    |> String.replace("\n", "\n\s\s")
    |> inject_into_file("lib/#{base}/endpoint.ex", after: "plug Plug.Head")
  end

  defp append_to_file(string, filename) do
    file = open(filename, [:append])
    IO.puts(file, string)
    File.close(file)
    Mix.shell.info [:green, "* appending to ", :reset, filename]
  end
end