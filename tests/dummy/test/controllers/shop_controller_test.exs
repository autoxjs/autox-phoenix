defmodule Dummy.ShopControllerTest do
  use Dummy.ConnCase
  alias Dummy.SeedSupport
  alias Autox.ContextUtils
  test "simple post create", %{conn: conn} do
    params = %{
      "data" => %{
        "type" => "shops",
        "attributes" => SeedSupport.shop_attributes
      }
    }
    conn = conn
    |> post("/api/shops", params)
    assert %{"data" => data} = json_response(conn, 201)
    assert %{"id" => _, "type" => "shops", "attributes" => attributes} = data
    assert %{"name" => "test shop", "location" => "testland", "inserted_at" => _, "updated_at" => _} = attributes
  end

  test "relational post create", %{conn: conn} do
    %{id: id} = SeedSupport.build_owner
    params = %{
      "data" => %{
        "type" => "shops",
        "attributes" => SeedSupport.shop_attributes,
        "relationships" => %{
          "owner" => %{
            "data" => %{
              "type" => "owners",
              "id" => id
            }
          }
        }
      }
    }
    conn = conn |> post("/api/shops", params)
    assert %{"data" => data} = json_response(conn, 201)
    assert %{
      "id" => _, 
      "type" => "shops", 
      "attributes" => _, 
      "relationships" => relationships, 
      "links" => %{"self" => _}
    } = data
    assert %{
      "owner" => owner, 
      "tacos" => tacos,
      "salsas" => salsas
    } = relationships
    assert %{
      "links" => %{"self" => _},
      "data" => %{ "id" => ^id, "type" => "owners"}
    } = owner
    assert %{"links" => %{"self" => _}} = tacos
    refute tacos["data"] == []
    assert %{"links" => %{"self" => _}} = salsas
    refute salsas["data"] == []
  end

  test "proper context", %{conn: conn} do
    %{email: email} = SeedSupport.build_user
    bob = SeedSupport.build_owner
    alice = SeedSupport.build_owner
    %{id: id} = SeedSupport.build_shop(bob)
    SeedSupport.build_shop(alice)

    path = conn |> session_path(:create)
    data = %{ "type" => "sessions", "attributes" => %{"email" => email, "password" => "password123"} }
    conn = conn |> post(path, %{"data" => data})
    path = conn |> session_path(:update)
    data = %{
      "type" => "sessions",
      "relationships" => %{"owner" => %{"data" => %{"id" => bob.id, "type" => "owners"}}} 
    }
    conn = conn
    |> ensure_recycled
    |> patch(path, %{"data" => data})

    conn2 = conn
    |> get("/ctx/shops", %{})

    assert bob == ContextUtils.get(conn2, :parent)

    assert %{"meta" => meta, "data" => data} = json_response(conn2, 200)

    assert meta["count"] == 1
    assert [shop] = data
    assert %{
      "id" => ^id,
      "type" => "shops"
    } = shop
  end
end
