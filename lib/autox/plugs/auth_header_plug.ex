defmodule Autox.AuthHeaderPlug do
  defmodule MissingServerMasterKey do
    defexception [:message]
    def exception(atom) do
      %__MODULE__{message: "You need to set the master-key with #{atom} in your config.exs files!"}
    end 
  end
  import Plug.Conn
  alias Fox.StringExt
  alias Autox.ForbiddenUtils, as: Fu

  def init([]), do: init(:autox_master_key)
  def init(atom) when is_atom(atom) do
    case atom |> master_key do
      nil -> raise MissingServerMasterKey, atom
      key -> 
        header = atom
        |> Atom.to_string
        |> StringExt.dasherize
        {header, key}
    end
  end

  def call(conn, {header, key}) do
    conn 
    |> extract_header(header) 
    |> ok?(key)
    |> case do
      {:error, msg} -> conn |> Fu.forbidden(msg)
      {:ok, _} -> conn
    end
  end

  defp extract_header(conn, header) do
    conn |> get_req_header(header) |> List.first
  end

  defp master_key(key) do
    Application.get_env(:autox, Autox.Defaults)[key]
  end

  defp ok?(nil,   _), do: {:error, "missing request master key"}
  defp ok?(key, key), do: {:ok, key}
  defp ok?(_  ,   _), do: {:error, "request key doesn't match server key"}
  
end