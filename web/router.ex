defmodule Autox.Router do
  use Autox.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Autox.RepoContextPlug, Autox.Repo
  end

  scope "/api", Autox do
    pipe_through :api

    the Shop do
      many [Taco, Salsa]
      one Owner
    end

    the Taco do
      many Shop
    end

    the Salsa do
      many Shop
    end

    the Owner do
      many Shop 
    end
  end
end
