defmodule Dummy.BreakupUtilsTest do
  use Dummy.ModelCase
  alias Dummy.Repo
  alias Dummy.Shop
  alias Dummy.Chair
  alias Dummy.Kitchen
  alias Autox.BreakupUtils, as: Bu
  alias Dummy.SalsasShopsRelationship
  import Dummy.SeedSupport
  setup do
    owner = build_owner
    shop = owner |> build_shop
    shop |> build_chair
    shop |> build_kitchen
    build_salsa |> salsa_to_shop(shop)
    {:ok, shop: Repo.preload(shop, [:owner, :chairs, :kitchen, :salsas])}
  end

  test "daac - existing - belongs_to", %{shop: shop} do
    params = %{"id" => shop.owner.id, "type" => "owners"}
    assert shop.owner_id
    assert {:update, changeset} = Bu.daac(Repo, shop, :owner, params)
    case changeset |> Repo.update do
      {:ok, %Shop{}=s} -> refute s.owner_id  
      {:error, cs} -> refute cs
    end
  end

  test "daac - existing - has_one", %{shop: shop} do
    params = %{"id" => shop.kitchen.id, "type" => "kitchens"}
    assert shop.kitchen.shop_id == shop.id
    assert {:update, changeset} = Bu.daac(Repo, shop, :kitchen, params)
    case changeset |> Repo.update do
      {:ok, %Kitchen{}=k} -> refute k.shop_id
      {:error, cs} -> refute cs
    end
  end

  test "daac - existing - has_many", %{shop: shop} do
    [chair] = shop.chairs
    params = %{"id" => chair.id, "type" => "chairs"}
    assert chair.shop_id == shop.id
    assert {:update, changeset} = Bu.daac(Repo, shop, :chairs, params)
    case changeset |> Repo.update do
      {:ok, %Chair{}=c} -> refute c.shop_id
      {:error, cs} -> refute cs
    end
  end

  test "daac - existing - through many-to-one", %{shop: shop} do
    [salsa] = shop.salsas
    params = %{"id" => salsa.id, "type" => "salsas"}
    assert {:delete, %SalsasShopsRelationship{}=relation} = Bu.daac(Repo, shop, :salsas, params)
    case relation |> Repo.delete do
      {:ok, %SalsasShopsRelationship{}} ->
        assert [] == shop |> assoc(:salsas) |> Repo.all
      {:error, cs} -> refute cs
    end
  end

end