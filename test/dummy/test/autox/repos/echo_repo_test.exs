defmodule Dummy.EchoRepoTest do
  use Dummy.ModelCase
  alias Autox.EchoRepo
  alias Dummy.Shop
  import Dummy.SeedSupport
  test "it should just ok stuff" do
    assert {:ok, shop} = %Shop{}
    |> Shop.create_changeset(shop_attributes)
    |> EchoRepo.insert

    shop_id = shop.id
    assert shop.name =~ "test"
    assert shop.location =~ "test"
    assert shop_id

    shop2 = EchoRepo.get(Shop, shop.id)
    assert %{id: ^shop_id} = shop2
    assert shop2.name == shop.name
    assert shop2.location == shop.location
  end
end