defmodule Autox.SessionModelPlug do
  defmodule SessionModelError do
   defexception [:message]
    def exception(_) do
      %__MODULE__{
        message: "No Session Present"
      }
    end 
  end
  alias Autox.SessionUtils
  def init, do: []
  def init(_), do: []

  def call(conn, _) do
    conn |> session_model
  end

  defp session_model(conn) do
    session = conn |> SessionUtils.current_session
    params = Map.put(conn.params, "model", session)
    %{conn | params: params}
  end
end