defmodule Autox.MetaUtils do
  defstruct collection_link: :string,
    namespace: :string,
    path: :string

  def from_conn(conn) do
    %__MODULE__{path: conn.request_path,
    collection_link: conn.request_path,
    namespace: conn.path_info |> List.first}
  end
end