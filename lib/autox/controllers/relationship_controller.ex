defmodule Autox.RelationshipController do
  @doc """
  Infers the association field from the path
  """
  def infer_relationship_field(%{path_info: paths}) when is_list(paths) do
    paths
    |> List.last
    |> Atom.to_existing_string
  end

  defmacro __using__(_opts) do
    quote location: :keep do
      @repo Module.get_attribute(__MODULE__, :repo)
      alias Autox.RelationalControllerConvention, as: RCC
      alias Autox.ContextUtils
      alias Autox.ChangesetUtils
      @changeset_view Module.get_attribute(__MODULE__, :changeset_view) || Autox.ChangesetView

      def repo(conn), do: @repo || ContextUtils.get!(conn, "repo")

      def show(conn, %{"parent" => parent}) do
        association_key = RCC.infer_relationship_field(conn)
        model = parent
        |> assoc(association_key)
        |> repo(conn).one
        links = %{self: conn.request_path}
        conn
        |> render("show.json", data: model, links: links)
      end

      def index(conn, %{"parent" => parent}) do
        association_key = RCC.infer_relationship_field(conn)
        models = parent
        |> assoc(association_key)
        |> repo(conn).all
        links = %{self: conn.request_path}
        conn
        |> render("index.json", data: models, links: links)
      end

      def create(conn, %{"parent" => parent, "child" => child}) do
        association_key = RCC.infer_relationship_field(conn)
        parent
        |> ChangesetUtils.create_relationship_changeset(association_key, child)
        |> repo(conn).insert
        |> case do
          {:ok, model} ->
            conn
            |> Plug.Conn.assigns(:data, model)
            |> send_resp(:no_content, "")
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(@changeset_view, "error.json", changeset: changeset) 
        end
      end

      defoverridable [show: 2, index: 2, create: 2]
    end
  end
end