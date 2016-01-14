defmodule Dummy.AutoxDefaultsTest do
  use Dummy.ModelCase

  test "default_repo" do
    assert Autox.default_repo
      == Dummy.Repo
  end
  test "default_user_class" do
    assert Autox.default_user_class
      == Dummy.User
  end
  test "default_session_class" do
    assert Autox.default_session_class
      == Dummy.Session
  end
end