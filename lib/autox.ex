defmodule Autox do
  @moduledoc """
  Use autox to rapidly scaffold and build most of the back-end and data-side
  front-end of an emberjs on phoenix application

  ## HowTo:
  Requirements: you'll need both phoenix and ember-cli installed

  Step 1. create an ember-addon
  ```sh
  ember addon backend
  cd backend
  ```

  Step 2. add this addon
  ```sh
  ember install ember-autox # command might be different if I publicly publish

  # Either do:
  ember ember-autox:init-phoenix

  # or:
  cd ..
  mix phoenix.new backend
  ```

  Step 3: Think about your application's data and write the `config/router.ex` file
  ```elixir
  scope "/api", Backend do
    the Shop do
      many Product
    end
    the Product
    ...
  end
  ```

  Step 4: run autox infer scaffold
  ```sh
  mix autox.infer.scaffold
  ```
  This builds all the controllers, views, and most of the models your app will need for both
  emberjs and phoenix

  Step 5: edit your back-end models and run infer migration
  ```sh
  mix autox.infer.migrations
  mix ecto.setup
  ```

  Step 6. Serve via phoenix, and install via ember
  ```sh
  iex -S mix phoenix.server
  ember release
  cd your-ember-front-end
  ember install backend
  ember s
  ```
  """
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Autox.Endpoint, []),
      # Start the Ecto repository
      supervisor(Autox.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Autox.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Autox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Autox.Endpoint.config_change(changed, removed)
    :ok
  end
end
