defmodule Autox.SessionUtilsTest do
  alias Autox.SessionUtils, as: Su
  use Dummy.ConnCase
  import Dummy.SeedSupport

  setup do
    conn = conn()
    user = build_user
    owner = build_owner
    {:ok, conn: conn, user: user, owner: owner}
  end

  test "serialize" do
    session = build_session
    assert Su.serialize(session) == session.id
  end
end