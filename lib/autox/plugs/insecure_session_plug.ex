defmodule Autox.InsecureSessionPlug do
  @moduledoc """
  lol fuck you security
  """
  alias Plug.Conn
  @behaviour Plug

  @cookie_opts [:domain, :max_age, :path, :secure, :http_only]
  def init(opts) do
    store        = Keyword.fetch!(opts, :store) |> convert_store
    key          = Keyword.fetch!(opts, :key)
    cookie_opts  = Keyword.take(opts, @cookie_opts)
    store_opts   = Keyword.drop(opts, [:store, :key] ++ @cookie_opts)
    store_config = store.init(store_opts)

    %{store: store,
      store_config: store_config,
      key: key,
      cookie_opts: cookie_opts}
  end

  defdelegate call(conn, opts), to: Plug.Session

  defp convert_store(store) do
    case Atom.to_string(store) do
      "Elixir." <> _ -> store
      reference      -> Module.concat(Plug.Session, String.upcase(reference))
    end
  end
end