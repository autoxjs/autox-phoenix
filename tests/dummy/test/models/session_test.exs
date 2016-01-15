defmodule Dummy.SessionTest do
  use Dummy.ModelCase
  alias Dummy.Session
  import Dummy.SeedSupport

  setup do
    {:ok, user: build_user}
  end

  test "create_changeset" do
    changeset = Session
    |> struct
    |> Session.create_changeset(session_attributes)
    assert changeset.valid?
  end
end