defmodule Dummy.Router do
  use Dummy.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug :fetch_session
    plug Autox.RepoContextPlug
    plug Autox.UnderscoreParamsPlug, "data"
  end

  pipeline :auth do
    plug Autox.AuthSessionPlug
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

    can_login!
  end

  scope "/api", Dummy do
    pipe_through [:api, :auth]
    can_logout!
    
    the Kitchen do
      one Shop
    end

    the Chair do
      one Shop
    end
  end

end
