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
  ember ember-autox:install

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
  def default_origin, do: Application.get_env(:autox, Autox.Defaults)[:host]
  def default_repo, do: Application.get_env(:autox, Autox.Defaults)[:repo]
  def default_endpoint, do: Application.get_env(:autox, Autox.Defaults)[:endpoint]
  def default_user_class, do: Application.get_env(:autox, Autox.Defaults)[:user_class]
  def default_error_view, do: Application.get_env(:autox, Autox.Defaults)[:error_view]
  def default_session_class, do: Application.get_env(:autox, Autox.Defaults)[:session_class]

end
