defmodule Autox.ResourceController do
  alias Fox.ListExt
  def infer_changeset_view(module) do
    module 
    |> Module.split
    |> ListExt.head
    |> Kernel.++(["ChangesetView"])
    |> Module.safe_concat
  end

  defmacro __using__(_) do
    quote location: :keep do
      alias Fox.AtomExt
      alias Autox.ResourceController
      alias Autox.ContextUtils
      alias Autox.ChangesetUtils
      alias Autox.MetaUtils
      alias Autox.QueryUtils
      @collection_key Module.get_attribute(__MODULE__, :collection_key) 
      || AtomExt.infer_collection_key(__MODULE__)

      @model_key Module.get_attribute(__MODULE__, :model_key)
      || AtomExt.infer_model_module(__MODULE__)

      @repo Module.get_attribute(__MODULE__, :repo)

      def repo(conn), do: @repo || ContextUtils.get!(conn, :repo)
      def preload_fields, do: []

      def index_query(_conn, params), do: @model_key |> QueryUtils.construct(params)
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
          nil -> struct(@model_key)
          parent -> parent |> Ecto.build_assoc(@collection_key)
        end
        |> @model_key.create_changeset(make_params)
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
            |> render("error.json", changeset: changeset)
        end
      end

      def show(conn, %{"model" => nil}) do
        show_core(conn, nil)
      end
      def show(conn, %{"model" => model}) do
        model = repo(conn)
        |> apply(:preload, [model, preload_fields])
        show_core(conn, model)
      end
      defp show_core(conn, model) do
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
            |> assign(:meta, MetaUtils.from_conn(conn))
            |> send_resp(:no_content, "")
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", changeset: changeset)
        end
      end

      def update(conn, %{"model" => model}=params) do
        change_params = params 
        |> ChangesetUtils.activemodel_paramify
        || params
        |> Dict.fetch!(@model_key |> Atom.to_string)
        model 
        |> @model_key.update_changeset(change_params)
        |> repo(conn).update
        |> case do
          {:ok, model} ->
            meta = conn |> MetaUtils.from_conn
            conn |> render("show.json", data: model, meta: meta)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", changeset: changeset) 
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