defmodule Autox.Router do
  use Autox.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug Autox.RepoContextPlug, Autox.Repo
    plug Autox.UnderscoreParamsPlug, "data"
  end

  scope "/api", Autox do
    pipe_through :api

    the Shop do
      many [Taco, Salsa, Chair]
      one [Owner, Kitchen]
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

    the Kitchen do
      one Shop
    end

    the Chair do
      one Shop
    end
  end
end
