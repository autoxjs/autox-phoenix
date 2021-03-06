defmodule Dummy.Mixfile do
  use Mix.Project

  def project do
    [app: :dummy,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Dummy, []},
     applications: [:phoenix, :cowboy, :logger, :gettext, :phoenix_pubsub,
                    :phoenix_ecto, :postgrex]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    autox = File.cwd! |> Path.join("../..") |> Path.expand

    [{:phoenix, "~> 1.2.0-rc"},
     {:phoenix_pubsub, "~> 1.0.0-rc"},
     {:phoenix_ecto, "~> 3.0-rc"},
     {:autox, path: autox},
     {:cors_plug, "~> 0.1"},
     {:postgrex, ">= 0.0.0"},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"}]
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
     "autox.reset": ["autox.destroy.migrations", "autox.infer.migrations", "ecto.reset"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
