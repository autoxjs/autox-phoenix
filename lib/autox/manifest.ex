defmodule Autox.Manifest do
  alias Fox.StringExt

  def pathify(model) do
    model
    |> descopify
    |> StringExt.dasherize
  end
  def descopify(model) do
    model
    |> Module.split
    |> List.last
    |> to_string
  end
  def infer_relationship_controller(model) do
    model
    |> Atom.to_string
    |> Kernel.<>("RelationshipController") 
    |> String.to_atom
  end
  def infer_collection_path(model) do
    model |> pathify |> StringExt.pluralize
  end
  def infer_controller(model) do
    model
    |> Atom.to_string
    |> Kernel.<>("Controller") 
    |> String.to_atom
  end

  defmacro can_login! do
    can_login_core([])
  end
  defmacro can_login!(sessionable) when is_atom(sessionable) do
    can_login_core([sessionable])
  end
  defmacro can_login!(sessionables) when is_list(sessionables) do
    can_login_core(sessionables)
  end
  defp can_login_core(_) do
    quote do
      resources "sessions", SessionController, only: [:show, :create], singleton: true
      resources "users", UserController, only: [:create]
    end
  end
  defmacro can_logout! do
    quote do
      resources "sessions", SessionController, only: [:update, :delete], singleton: true
      resources "sessions", SessionController, only: [:show, :update, :delete]
      resources "users", UserController, only: [:update, :show]
    end
  end

  @an_actions [:show, :index, :update, :create, :delete]
  defmacro an(model, actions, do: context) do
    an_core model, actions, do: context
  end
  defmacro an(model, do: context) do
    an_core model, @an_actions, do: context
  end
  defmacro an(model, actions) when is_list(actions) do
    an_core model, actions, do: nil
  end
  defmacro an(model) do
    an_core model, @an_actions, do: nil
  end

  defmacro the(model, actions, do: context) do
    an_core model, actions, do: context
  end
  defmacro the(model, do: context) do
    an_core model, @an_actions, do: context
  end
  defmacro the(model, actions) when is_list(actions) do
    an_core model, actions, do: nil
  end
  defmacro the(model) do
    an_core model, @an_actions, do: nil
  end
  
  defp an_core(model, actions, do: context) do
    quote do
      path = Autox.Manifest.infer_collection_path(unquote(model))
      controller = Autox.Manifest.infer_controller(unquote(model))

      resources path, controller, [only: unquote(actions)], do: unquote(context)
    end
  end

  @many_actions [:index, :delete, :create]
  defmacro many(model) do
    many_core(model, @many_actions)
  end
  defmacro many(model, actions) do
    many_core(model, actions)
  end

  defp many_core(models, actions) when is_list(models) do
    delete? = :delete in actions
    index? = :index in actions
    create? = :create in actions
    quote do
      for model <- unquote(models) do
        path = Autox.Manifest.infer_collection_path(model)
        relation_path = "relationships/" <> path
        controller = Autox.Manifest.infer_relationship_controller(model)
        if unquote(index?) do
          resources path, controller, only: [:index]
        end
        if unquote(create?) do
          resources relation_path, controller, only: [:create]
        end
        if unquote(delete?) do
          resources relation_path, controller, only: [:delete], singleton: true
        end
      end
    end
  end
  defp many_core(model, actions), do: many_core([model], actions)

  @one_actions [:show, :delete, :create]
  defmacro one(model) do
    one_core(model, @one_actions)
  end
  defmacro one(model, actions) do
    one_core(model, actions)
  end

  defp one_core(models, actions) when is_list(models) do
    show? = :show in actions
    actions = actions |> Enum.reject(&(&1 == :show))
    
    quote do
      for model <- unquote(models) do
        path = Autox.Manifest.pathify(model)
        relation_path = "relationships/" <> path
        controller = Autox.Manifest.infer_relationship_controller(model)
        if unquote(show?) do
          resources path, controller, only: [:show], singleton: true  
        end
        resources relation_path, controller, only: unquote(actions), singleton: true
      end
    end
  end
  defp one_core(model, actions), do: one_core([model], actions)
end