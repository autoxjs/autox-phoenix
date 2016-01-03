defmodule Autox.SalsaRelationshipControllerTest do
  use Autox.ConnCase
  import Autox.SeedSupport
  alias Autox.Repo

  setup do
    conn = conn()
    shop = build_shop
    salsa = build_salsa
    {:ok, conn: conn, shop: shop, salsa: salsa}
  end

  test "it should properly show", %{conn: conn, shop: shop, salsa: salsa} do
    %{salsa: %{id: salsa_id}, shop: shop} = salsa |> salsa_to_shop(shop)
    path = conn |> shop_salsa_relationship_path(:index, shop.id)
    assert path == "/api/shops/#{shop.id}/salsas"
    response = conn
    |> get(path, %{})
    |> json_response(200)

    assert %{"data" => data, "links" => links} = response
    assert [%{
      "id" => ^salsa_id,
      "type" => "salsas",
      "attributes" => _,
      "relationships" => _
    }] = data
    assert %{
      "self" => "/api/shops/#{shop.id}/salsas"
    } == links
  end

  test "it should relate the shop with the salsa", %{conn: conn, shop: shop, salsa: salsa} do
    path = conn |> shop_salsa_relationship_path(:create, shop.id)
    assert path == "/api/shops/#{shop.id}/relationships/salsas"

    data = %{
      "id" => salsa.id,
      "type" => "salsas",
      "attributes" => %{
        "authorization-key" => "x-men wolverine"
      }
    }
    conn
    |> post(path, %{"data" => data})
    |> response(204)

    shop = Repo.get(Autox.Shop, shop.id)
    assert [actual_salsa] = shop |> assoc(:salsas) |> Repo.all
    assert actual_salsa.id == salsa.id
    assert [relationship] = shop |> assoc(:salsas_shops_relationship) |> Repo.all
    assert relationship.salsa_id == salsa.id
    assert relationship.shop_id == shop.id
    assert relationship.authorization_key == "x-men wolverine"
  end

  test "it should destroy relationships", %{conn: conn, shop: shop, salsa: salsa} do
    %{shop: shop, salsa: salsa} = salsa_to_shop(salsa, shop)
    data = %{
      "id" => salsa.id,
      "type" => "salsas"
    }
    path = conn |> shop_salsa_relationship_path(:delete, shop.id)
    assert path == "/api/shops/#{shop.id}/relationships/salsas"

    conn
    |> delete(path, %{"data" => data})
    |> response(204)

    shop = Repo.get(Autox.Shop, shop.id)
    assert [] == shop |> assoc(:salsas_shops_relationship) |> Repo.all
    assert [] == shop |> assoc(:salsas) |> Repo.all
    salsa = Repo.get(Autox.Salsa, salsa.id)
    assert [] == salsa |> assoc(:shops) |> Repo.all
    assert [] == salsa |> assoc(:salsas_shops_relationship) |> Repo.all
  end
end