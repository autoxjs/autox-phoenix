defmodule Dummy.UnderscoreParamsPlugTest do
  alias Autox.UnderscoreParamsPlug, as: Upp
  use Dummy.ConnCase
  
  test "it should work on non conns", %{conn: conn} do
    conn = conn |> Upp.call("data")
    assert conn
  end

  test "it should properly underscore all param keys", %{conn: conn} do
    params = %{
      "data" => %{
        "id" => 32,
        "type" => "various-things",
        "attributes" => %{
          "secret-sauce" => "applesauce"
        },
        "relationships" => %{
          "onsite-trucks" => %{
            "data" => [
              %{
                "id" => 3,
                "type" => "onsite-trucks"
              },
              %{
                "id" => 4,
                "type" => "onsite-trucks",
                "attributes" => %{
                  "awkwardSilence" => true
                }
              }
            ]
          }
        }
      }
    }
    conn = %{conn|params: params}
    |> Upp.call("data")
    assert conn.params == %{
      "data" => %{
        "id" => 32,
        "type" => "various-things",
        "attributes" => %{
          "secret_sauce" => "applesauce"
        },
        "relationships" => %{
          "onsite_trucks" => %{
            "data" => [
              %{
                "id" => 3,
                "type" => "onsite-trucks"
              },
              %{
                "id" => 4,
                "type" => "onsite-trucks",
                "attributes" => %{
                  "awkward_silence" => true
                }
              }
            ]
          }
        }
      }
    }
  end
end