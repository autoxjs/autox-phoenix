defmodule Dummy.AutoPaginatePlugTest do
  use Dummy.ConnCase

  test "it should properly provide default params", %{conn: conn} do
    params = conn 
    |> get("/api/owners", %{})
    |> Map.get(:params)
    assert params["page"] == %{"limit" => 25, "offset" => 0}
    assert params["sort"] == "-id"
  end

  test "it should not override existing params", %{conn: conn} do
    params = conn 
    |> get("/api/owners", %{"page" => %{"offset" => 3}, "sort" => "-inserted_at"})
    |> Map.get(:params)

    assert params["page"] == %{"limit" => 25, "offset" => 3}
    assert params["sort"] == "-inserted_at"
  end

  test "it should cap overly large limits", %{conn: conn} do
    params = conn 
    |> get("/api/owners", %{"page" => %{"limit" => 99999}})
    |> Map.get(:params)

    assert params["page"] == %{"limit" => 100, "offset" => 0}
    assert params["sort"] == "-id"
  end
end