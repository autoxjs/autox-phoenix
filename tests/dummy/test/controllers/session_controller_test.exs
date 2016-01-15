defmodule Dummy.SessionControllerTest do
  use Dummy.ConnCase
  alias Autox.SessionUtils, as: Su
  import Dummy.SeedSupport
  
  setup do
    conn = conn()
    {:ok, conn: conn, user: build_user}
  end

  test "create session", %{conn: conn, user: user} do
    %{email: email, remember_token: token, id: user_id} = user
    path = conn |> session_path(:create)
    assert path == "/api/sessions"
    data = %{ 
      "type" => "sessions",
      "attributes" => %{"email" => email, "password" => "password123"} }
    conn = conn |> post(path, %{"data" => data})
    assert conn |> get_resp_header("_dummy_key") |> List.first
    assert conn |> Su.logged_in?
    assert %{"data" => data} = conn |> json_response(201)
    assert %{
      "id" => ^user_id,
      "type" => "sessions",
      "attributes" => attributes,
      "relationships" => %{"user" => user_relation}
    } = data
    assert %{
      "email" => ^email,
      "remember_token" => ^token
    } = attributes
    assert %{
      "links" => %{
        "self" => _
      },
      "data" => %{
        "id" => ^user_id,
        "type" => "users"
      }
    } = user_relation
  end

  test "show session", %{conn: conn, user: %{email: email}} do
    path = conn |> session_path(:create)
    data = %{ "type" => "sessions", "attributes" => %{"email" => email, "password" => "password123"} }
    conn = conn |> post(path, %{"data" => data})
    conn |> Su.logged_in? |> assert
    path = conn |> session_path(:show)
    %{"data" => data} = conn
    |> ensure_recycled
    |> get(path, %{})
    |> json_response(200)
    assert %{
      "id" => _, "type" => "sessions", "attributes" => _, "relationships" => _
    } = data
  end

  test "show session - forbidden", %{conn: conn} do
    path = conn |> session_path(:show)
    resp = conn
    |> get(path, %{})
    |> json_response(200)
    assert %{"data" => nil} = resp
  end

  test "update session", %{conn: conn, user: %{id: user_id, email: email}} do
    owner = build_owner
    path = conn |> session_path(:create)
    data = %{ "type" => "sessions", "attributes" => %{"email" => email, "password" => "password123"} }
    conn = conn |> post(path, %{"data" => data})
    path = conn |> session_path(:update)
    data = %{
      "type" => "sessions",
      "relationships" => %{"owner" => %{"data" => %{"id" => owner.id, "type" => "owners"}}} 
    }
    conn = conn
    |> ensure_recycled
    |> put(path, %{"data" => data})

    session = conn
    |> ensure_recycled
    |> get("/api/sessions/33", %{})
    |> Su.current_session

    assert session.user_id == user_id
    assert session.owner_id == owner.id
  end

  test "update session via delete-post", %{conn: conn, user: %{id: user_id, email: email, remember_token: token}} do
    owner = build_owner
    path = conn |> session_path(:create)
    data = %{ "type" => "sessions", "attributes" => %{"email" => email, "password" => "password123"} }
    conn = conn 
    |> post(path, %{"data" => data})
    |> ensure_recycled
    |> delete(path, %{})

    data = %{
      "type" => "sessions",
      "attributes" => %{"remember_token" => token},
      "relationships" => %{"owner" => %{"data" => %{"id" => owner.id, "type" => "owners"}}} 
    }
    conn = conn
    |> ensure_recycled
    |> post(path, %{"data" => data})

    session = conn
    |> ensure_recycled
    |> get("/api/sessions/33", %{})
    |> Su.current_session

    assert session.id == user_id
    assert session.user_id == user_id
    assert session.owner_id == owner.id
  end

  test "delete session", %{conn: conn, user: %{email: email}} do
    path = conn |> session_path(:create)
    data = %{ "type" => "sessions", "attributes" => %{"email" => email, "password" => "password123"} }
    conn = conn |> post(path, %{"data" => data})
    dummy_key = conn |> get_resp_header("_dummy_key") |> List.first
    path = conn |> session_path(:delete)
    conn = conn |> ensure_recycled |> delete(path, %{})
    conn
    |> Su.logged_in?
    |> refute

    refute dummy_key == conn |> get_resp_header("_dummy_key") |> List.first

  end
end