defmodule Dummy.Router do
  use Dummy.Web, :router

  def has_owner?(%{owner: %{id: _}}), do: true
  def has_owner?(_), do: false
  @moduledoc """
  Upcoming:
  ## Characteristics
  Characteristics should be a bit like the regular plug pipeline,
  except it's all compile-time manifest about the underlining data.

  For example:
  characteristics :physical do
    is Filmable
    is Historical
    is GridLocateable, {:x, :y, :z}
  end
  """
  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug :fetch_session
    plug Autox.RepoContextPlug
    plug Autox.UnderscoreParamsPlug, "data"
  end

  pipeline :realtime do
    plug Autox.BroadcastSessionPlug
  end

  pipeline :auth do
    plug Autox.AuthSessionPlug
  end

  pipeline :auth2 do
    plug Autox.AuthSessionPlug, {__MODULE__, :has_owner?}
  end

  pipeline :admin do
    plug Autox.AuthHeaderPlug
  end

  pipeline :owner do
    plug Autox.SessionContextPlug, session: :owner, context: :parent
  end

  scope "/ctx", Dummy do
    pipe_through [:api, :auth, :owner]
    the Shop
  end

  scope "/api", Dummy do
    pipe_through :api

    the Shop do
      many [Taco, Salsa, Chair, History]
      one [Owner, Kitchen]
    end

    the Salsa do
      many [Shop, History]
    end

    the Owner do
      many Shop 
    end

    can_login!
  end

  scope "/api", Dummy do
    pipe_through [:api, :auth, :auth2, :realtime]

    the Taco do
      many Shop
    end
  end

  scope "/api", Dummy do
    pipe_through [:api, :auth]
    can_logout!
    
    the Chair do
      one Shop
    end
  end

  scope "/api", Dummy do
    pipe_through [:api, :admin]

    the Kitchen do
      one Shop
    end
  end

end
