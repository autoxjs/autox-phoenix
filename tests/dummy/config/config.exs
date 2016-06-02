# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :dummy, Dummy.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "DfFlUFwjMtO3cC//M9MZBEfB2lU+U2hvw1i/I1te8AT/Pw+Pshx0Cn372/atFet9",
  render_errors: [accepts: ~w(json)],
  pubsub: [name: Dummy.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :dummy,
  ecto_repos: [Dummy.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

## Autox installed configurations
config :plug, :mimes, %{"application/vnd.api+json" => ["json-api"]}
config :autox, Autox.Defaults,
  base: Dummy,
  repo: Dummy.Repo,
  session_header: "autox-remember-token",
  autox_master_key: "sore ue subete ga tsunagareru",
  endpoint: Dummy.Endpoint,
  error_view: Dummy.ErrorView,
  user_class: Dummy.User,
  session_class: Dummy.Session
