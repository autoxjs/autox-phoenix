defmodule Dummy.Router do
  use Dummy.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug :fetch_session
    plug Autox.RepoContextPlug, Dummy.Repo
    plug Autox.UnderscoreParamsPlug, "data"
  end

  pipeline :auth do
    plug Autox.ChangeSessionPlug
  end

  scope "/api", Dummy do
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

  scope "/api", Dummy do
    pipe_through [:api, :auth]
    can_logout!
    can_login!
  end
end
