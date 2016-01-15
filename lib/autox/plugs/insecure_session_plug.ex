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

  def call(conn, config) do
    Conn.put_private(conn, :plug_session_fetch, fetch_session(config))
  end

  defp convert_store(store) do
    case Atom.to_string(store) do
      "Elixir." <> _ -> store
      reference      -> Module.concat(Plug.Session, String.upcase(reference))
    end
  end

  defp fetch_session(config) do
    %{store: store, store_config: store_config, key: key} = config

    fn conn ->
      {sid, session} =
        if cookie = header_cookie(conn, key) do
          store.get(conn, cookie, store_config)
        else
          {nil, %{}}
        end

      conn
      |> Conn.put_private(:plug_session, session)
      |> Conn.put_private(:plug_session_fetch, :done)
      |> Conn.register_before_send(before_send(sid, config))
    end
  end

  defp header_cookie(conn, key) do
    conn
    |> Conn.get_req_header(key)
    |> List.first
    || conn.cookies[key]
  end

  defp before_send(sid, config) do
    fn conn ->
      case Map.get(conn.private, :plug_session_info) do
        :write ->
          value = put_session(sid, conn, config)
          put_cookie(value, conn, config)
        :drop ->
          if sid do
            delete_session(sid, conn, config)
            delete_cookie(conn, config)
          else
            conn
          end
        :renew ->
          if sid, do: delete_session(sid, conn, config)
          value = put_session(nil, conn, config)
          put_cookie(value, conn, config)
        :ignore ->
          conn
        nil ->
          conn
      end
    end
  end

  defp put_session(sid, conn, %{store: store, store_config: store_config}),
    do: store.put(conn, sid, conn.private[:plug_session], store_config)

  defp delete_session(sid, conn, %{store: store, store_config: store_config}),
    do: store.delete(conn, sid, store_config)

  defp put_cookie(value, conn, %{cookie_opts: opts, key: key}) do 
    conn
    |> Conn.put_resp_header(key, value)
    |> Conn.put_resp_cookie(key, value, opts)
  end

  defp delete_cookie(conn, %{cookie_opts: opts, key: key}) do
    conn
    |> Conn.delete_resp_header(key)
    |> Conn.delete_resp_cookie(key, opts)
  end
end