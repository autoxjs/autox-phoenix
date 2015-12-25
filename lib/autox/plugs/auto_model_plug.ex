defmodule Autox.AutoModelPlug do
  defmodule AutoModelError do
   defexception [:message]

    def exception(_) do
      %__MODULE__{
        message: "You forgot to provide the model class"
      }
    end 
  end
  alias Autox.ContextUtils
  alias Phoenix.MissingParamError
  def init(model) when is_atom(model), do: model

  def call(conn, model) do
    conn |> auto_model(model)
  end

  defp auto_model(conn, model_class) when is_atom(model_class) do
    primary_id = Map.get(conn.params, "id")
    repo = conn |> ContextUtils.get!(:repo)
    unless primary_id do
      raise MissingParamError, key: "id"
    end
    model = model_class |> repo.get_by!(id: primary_id)
    params = Map.put(conn.params, "model", model)
    %{conn | params: params}
  end
end