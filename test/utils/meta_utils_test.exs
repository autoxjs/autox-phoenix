defmodule Autox.MetaUtilsTest do
  alias Autox.MetaUtils, as: Mu
  use Autox.ConnCase
  import Autox.SeedSupport

  setup do
    conn = conn()
    %{salsa: salsa, shop: shop} = salsa_to_shop(build_salsa, build_shop)
    {:ok, conn: conn, salsa: salsa, shop: shop}
  end

  test "it should infer the namespace and collection", %{conn: conn, shop: shop} do
    path = "/api/shops"
    meta = conn 
    |> get(path, %{})
    |> Mu.from_conn

    assert meta.valid?
  end
end