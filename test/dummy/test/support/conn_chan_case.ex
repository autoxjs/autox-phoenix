defmodule Dummy.ConnChanCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use Phoenix.ChannelTest
      alias Dummy.Repo
      import Plug.Conn
      import Phoenix.ConnTest, except: [connect: 2]
      import Ecto.Model
      import Ecto.Query, only: [from: 2]

      import Dummy.Router.Helpers
      # The default endpoint for testing
      @endpoint Dummy.Endpoint
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Dummy.Repo, [])
    end

    {:ok, conn: Phoenix.ConnTest.conn()}
  end
end