defmodule Autox.OwnerControllerTest do
  alias Autox.Owner
  use Autox.ConnCase
  alias Autox.SeedSupport

  test "simple post create", %{conn: conn} do
    params = %{
      "data" => %{
        "type" => "owners",
        "attributes" => SeedSupport.owner_attributes
      }
    }
    conn = conn
    |> post("/api/owners", params)
    assert %{"data" => data} = json_response(conn, 201)
    assert %{
      "id" => id,
      "type" => "owners",
      "attributes" => attributes,
      "relationships" => relationships
    } = data
    owner = Repo.get(Owner, id) |> Repo.preload([:shops])
    assert [] == owner.shops
    assert %{"name" => _, "inserted_at" => _, "updated_at" => _} = attributes
    assert %{
      "shops" => %{
        "links" => %{"self" => _}
      }
    } = relationships
  end
end