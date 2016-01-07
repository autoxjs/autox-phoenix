defmodule Dummy.BroadcastSessionPlugTest do
  use Dummy.ConnChanCase
  alias Autox.SessionUtils
  alias Dummy.UserSocket
  import Dummy.SeedSupport
  
  setup do
    user = build_user
    conn = conn() 
    |> post("/api/sessions", %{"data" => %{"type" => "sessions", "attributes" => session_attributes}})

    {:ok, socket} = UserSocket |> connect(%{"user_id" => user.id})
    topic = "users:#{user.id}"
    {:ok, socket: socket, user: user, conn: conn, topic: topic}
  end

  test "creating tacos should trigger broadcast", %{conn: conn, topic: topic} do
    assert conn |> SessionUtils.logged_in?

    @endpoint.subscribe(self(), topic)
    path = conn |> taco_path(:create)
    data = %{"type" => "tacos", "attributes" => taco_attributes}
    conn
    |> post(path, %{"data" => data})
    |> json_response(201)
    |> assert

    assert_broadcast "update", %{data: data, meta: _, links: _}
    assert %{id: _, links: _, type: :tacos, attributes: attributes, relationships: relationships} = data    
    assert %{
      name: "al pastor",
      calories: 9000
    } = attributes
    assert %{
      shops: %{
        links: _
      }
    } = relationships
  end

  test "deleting tacos should trigger broadcast", %{conn: conn, topic: topic} do
    assert conn |> SessionUtils.logged_in?

    @endpoint.subscribe(self(), topic)
    taco = build_taco
    path = conn |> taco_path(:delete, taco.id)
    conn
    |> delete(path, %{})
    |> response(204)
    |> assert

    assert_broadcast "destroy", %{data: data, meta: _, links: _}
    assert %{id: _, links: _, type: :tacos, attributes: attributes, relationships: relationships} = data    
    assert %{
      name: "al pastor",
      calories: 9000
    } = attributes
    assert %{
      shops: %{
        links: _
      }
    } = relationships
  end

  test "creating taco relationships should not fuck it all up", %{conn: conn, topic: topic} do
    @endpoint.subscribe self, topic
    shop = build_shop
    taco = build_taco
    path = conn |> taco_shop_relationship_path(:create, taco.id)
    data = %{"type" => "shops", "id" => shop.id}
    conn
    |> post(path, %{"data" => data})
    |> response(204)
    |> assert
  end
end