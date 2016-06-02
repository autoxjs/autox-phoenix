defmodule Dummy.HistoryRelationshipControllerTest do
  use Dummy.ConnCase
  import Dummy.SeedSupport
  alias Dummy.Repo

  setup do
    salsa = build_salsa
    {:ok, salsa: salsa}
  end

  test "it should create history", %{conn: conn, salsa: salsa} do
    path = conn |> salsa_history_relationship_path(:create, salsa.id)
    assert path == "/api/salsas/#{salsa.id}/relationships/histories"
    data = %{
      "type" => "histories",
      "attributes" => %{
        "type" => "single",
        "name" => "test-history"
      }
    }
    assert conn
    |> post(path, %{"data" => data})
    |> response(204)

    assert [history] = salsa
    |> assoc(:histories)
    |> Repo.all

    assert history.type == "single"
    assert history.name == "test-history"
  end
end
