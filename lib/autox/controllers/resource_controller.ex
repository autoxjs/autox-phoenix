defmodule Autox.ResourceController do
  defmacro __using__(opts\\[]) do
    quote location: :keep do
      use Fox.AtomExt
      alias Autox.ContextUtils
      alias Autox.ChangesetUtils
      alias Autox.MetaUtils
      @changeset_view Module.get_attribute(__MODULE__, :changeset_view) || Autox.ChangesetView
      @repo Module.get_attribute(__MODULE__, :repo)

      def repo(conn), do: @repo || ContextUtils.get!(conn, :repo)
      def preload_fields, do: []

      def index_query(_conn, _params), do: infer_model_module
      def index(conn, params) do
        models = conn
        |> index_query(params)
        |> repo(conn).all
        meta = conn |> MetaUtils.from_conn
        render(conn, "index.json", data: models, meta: meta)
      end

      def create(conn, params) do
        make_params = params 
        |> ChangesetUtils.activemodel_paramify

        case conn |> ContextUtils.get(:parent) do
          nil -> struct(infer_model_module)
          parent -> parent |> Ecto.build_assoc(infer_collection_key)
        end
        |> infer_model_module.create_changeset(make_params)
        |> repo(conn).insert
        |> case do
          {:ok, model} ->
            meta = conn |> MetaUtils.from_conn
            conn
            |> put_status(:created)
            |> render("show.json", data: model, meta: meta)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(@changeset_view, "error.json", changeset: changeset)
        end
      end

      def show(conn, %{"model" => model}) do
        model = model |> repo(conn).preload(preload_fields)
        meta = conn |> MetaUtils.from_conn
        conn |> render("show.json", data: model, meta: meta)
      end

      def delete(conn, %{"model" => model}) do
        model 
        |> repo(conn).delete
        |> case do
          {:ok, model} ->
            conn
            |> assign(:data, model)
            |> send_resp(:no_content, "")
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(@changeset_view, "error.json", changeset: changeset)
        end
      end

      def update(conn, %{"model" => model}=params) do
        change_params = params 
        |> ChangesetUtils.activemodel_paramify
        || params
        |> Dict.fetch!(infer_model_key |> Atom.to_string)
        model 
        |> infer_model_module.update_changeset(change_params)
        |> repo(conn).update
        |> case do
          {:ok, model} ->
            meta = conn |> MetaUtils.from_conn
            conn |> render("show.json", data: model, meta: meta)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(@changeset_view, "error.json", changeset: changeset) 
        end
      end

      defoverridable [create: 2,
        delete: 2,
        show: 2,
        update: 2,
        index: 2,
        index_query: 2,
        preload_fields: 0]
    end    
  end
end