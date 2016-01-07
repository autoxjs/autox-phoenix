defmodule Dummy.KitchenControllerTest do
  use Dummy.ConnCase
  import Dummy.SeedSupport

  setup do
    conn = conn()
    key = Application.get_env(:autox, Autox.Defaults)[:autox_master_key]
    {:ok, conn: conn, kitchen: build_kitchen, key: key}
  end

  test "it should properly show", %{conn: conn, key: key, kitchen: %{id: id}} do
    path = conn |> kitchen_path(:show, id)
    conn
    |> put_req_header("autox-master-key", key)
    |> get(path, %{})
    |> json_response(200)
    |> assert
  end

  test "it should reject those without the key", %{conn: conn, kitchen: %{id: id}} do
    path = conn |> kitchen_path(:show, id)
    conn
    |> get(path, %{})
    |> json_response(403)
    |> assert
  end
end