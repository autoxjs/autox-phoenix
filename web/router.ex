defmodule Autox.Router do
  use Autox.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Autox do
    pipe_through :api
  end
end
