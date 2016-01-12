defmodule Dummy.Endpoint do
  use Phoenix.Endpoint, otp_app: :dummy

  socket "/socket", Dummy.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :dummy, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_dummy_key",
    signing_salt: "tXVNJL9p",
    http_only: false,
    max_age: 26_280_000 # 10 months

  plug CORSPlug,
    origin: ["http://localhost:4200"],
    headers: ["Authorization", "Content-Type", "Accept", "Origin",
              "User-Agent", "DNT","Cache-Control", "X-Mx-ReqToken",
              "Keep-Alive", "X-Requested-With", "If-Modified-Since",
              "X-CSRF-Token", "autox-master-key"] ++ [Autox.default_session_header]

  plug Dummy.Router
end
