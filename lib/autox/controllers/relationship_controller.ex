defmodule Autox.RelationshipController do
  @doc """
  Infers the association field from the path
  """
  def infer_relationship_field(%{path_info: paths}) when is_list(paths) do
    paths
    |> List.last
    |> String.to_existing_atom
  end

  defmacro __using__(_opts) do
    quote location: :keep do
      @repo Module.get_attribute(__MODULE__, :repo)
      alias Autox.RelationshipController, as: Rc
      alias Autox.ContextUtils, as: Cu
      alias Autox.RelationUtils, as: Ru
      alias Autox.BreakupUtils, as: Bu
      @changeset_view Module.get_attribute(__MODULE__, :changeset_view) || Autox.ChangesetView

      def repo(conn), do: @repo || Cu.get!(conn, :repo)

      def show(conn, %{"parent" => parent}) do
        association_key = Rc.infer_relationship_field(conn)
        model = parent
        |> assoc(association_key)
        |> repo(conn).one
        links = %{self: conn.request_path}
        conn
        |> render("show.json", data: model, links: links)
      end

      def index(conn, %{"parent" => parent}) do
        association_key = Rc.infer_relationship_field(conn)
        models = parent
        |> assoc(association_key)
        |> repo(conn).all
        links = %{self: conn.request_path}
        conn
        |> render("index.json", data: models, links: links)
      end

      def create(conn, %{"parent" => parent, "data" => data}) do
        repo = repo(conn)
        association_key = Rc.infer_relationship_field(conn)
        Ru.creative_action_and_changeset(repo, parent, association_key, data)
        |> case do
          {:insert, changeset} -> repo.insert(changeset)
          {:update, changeset} -> repo.update(changeset)
          other -> other
        end
        |> case do
          {:ok, model} ->
            conn
            |> Plug.Conn.assign(:data, model)
            |> send_resp(:no_content, "")
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(@changeset_view, "error.json", changeset: changeset) 
        end
      end

      def delete(conn, %{"parent" => parent, "data" => data}) do
        repo = repo(conn)
        association_key = Rc.infer_relationship_field(conn)
        Bu.destructive_action_and_changeset(repo, parent, association_key, data)
        |> case do
          {:delete, model} -> repo.delete(model)
          {:update, changeset} -> repo.update(changeset)
          other -> other
        end
        |> case do
          {:ok, model} ->
            conn
            |> Plug.Conn.assign(:data, model)
            |> send_resp(:no_content, "")
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(@changeset_view, "error.json", changeset: changeset) 
        end
      end

      defoverridable [show: 2, index: 2, create: 2, delete: 2]
    end
  end
end