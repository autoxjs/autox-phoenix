defmodule Dummy.MetaUtilsTest do
  alias Autox.MetaUtils, as: Mu
  use Dummy.ConnCase
  import Dummy.SeedSupport

  setup do
    conn = conn()
    %{salsa: salsa, shop: shop} = salsa_to_shop(build_salsa, build_shop)
    {:ok, conn: conn, salsa: salsa, shop: shop}
  end

  test "it should infer the namespace and collection", %{conn: conn} do
    path = "/api/shops"
    meta = conn 
    |> get(path, %{})
    |> Mu.from_conn

    assert meta.valid?
  end

  test "it should properly handle next and prev paths" do
    page = %{
      "offset" => 0,
      "limit" => 25
    }
    models = ["dog"]
    expected = [
      other_queries: "", 
      this_path: "page%5Blimit%5D=25&page%5Boffset%5D=0",
      next_path: "page%5Blimit%5D=25&page%5Boffset%5D=25"
    ]
    assert Mu.link_paths(%{"page" => page}, models) == expected
      

    page = %{
      "offset" => 25,
      "limit" => 25
    }
    models = ["dog"]
    expected = [
      other_queries: "", 
      this_path: "page%5Blimit%5D=25&page%5Boffset%5D=25",
      next_path: "page%5Blimit%5D=25&page%5Boffset%5D=50",
      prev_path: "page%5Blimit%5D=25&page%5Boffset%5D=0"
    ]
    assert Mu.link_paths(%{"page" => page}, models) == expected
  end
end