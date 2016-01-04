defmodule Autox.Mixfile do
  use Mix.Project

  def project do
    [app: :autox,
     version: version,
     elixir: "~> 1.0",
     description: description,
     name: "autox",
     source_url: "https://github.com/foxnewsnetwork/autox",
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  @doc """
  Read the version off of the package.json file
  """
  @version ~r/"version":\s+"([a-zA-Z\d\.]+)"/
  def version do
    json = File.cwd!
    |> Path.join("package.json")
    |> File.read!
    @version
    |> Regex.scan(json)
    |> List.first
    |> List.last
  end

  def application do
    [applications: [:phoenix, :fox, :ecto]]
  end

  defp package do
    [maintainers: ["Thomas Chen - (foxnewsnetwork)"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/foxnewsnetwork/autox"}]
  end

  defp description do
    """
    Scaffold / run-time tool for building ember phoenix tools
    """
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.1"},
     {:fox, "~> 0.1"},
     {:pipe, "~> 0.0.2"},
     {:comeonin, "~> 1.1"},
     {:phoenix_ecto, "~> 2.0"},
     {:phoenix_html, "~> 2.3", only: [:dev, :test]},
     
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:postgrex, ">= 0.0.0", optional: true},
     {:gettext, "~> 0.9", optional: true},
     {:cowboy, "~> 1.0", optional: true}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "autox.reset": ["autox.destroy.migrations", "autox.infer.migrations", "ecto.reset"]]
  end
end
