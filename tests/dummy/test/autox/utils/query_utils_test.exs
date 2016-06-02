defmodule Autox.QueryUtilsTest do
  alias Autox.QueryUtils, as: Qu
  use Dummy.ConnCase
  import Dummy.SeedSupport
  alias Dummy.User
  setup do
    user = build_user
    {:ok, user: user}
  end

  test "consider_filtering", %{user: user} do
    filters = %{
      "email" => ">=cummy@test.co"
    }
    assert [u] = User |> Qu.consider_filtering(%{"filter" => filters}) |> Repo.all
    assert u.id == user.id

    filters = %{
      "email" => ">=eummy@test.co"
    }
    assert [] == User |> Qu.consider_filtering(%{"filter" => filters}) |> Repo.all

    filters = %{
      "email" => "dummy@test.co,dumbass@test.com,dipshit@quiz.org"
    }
    assert [u] = User |> Qu.consider_filtering(%{"filter" => filters}) |> Repo.all
    assert u.id == user.id
  end

  test "consider_sorting" do
    assert User |> Qu.consider_sorting(%{"sort" => "-email,password_hash"})
  end
end
