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

  @has_actions [:update, :delete, :create]
  defmacro many(model) do
    many_core(model, @has_actions)
  end
  defmacro many(model, actions) do
    many_core(model, actions)
  end

  defp many_core(models, _actions) when is_list(models) do
    quote do
      for model <- unquote(models) do
        path = Autox.Manifest.infer_collection_path(model)
        relation_path = "relationships/" <> path
        controller = Autox.Manifest.infer_relationship_controller(model)

        resources relation_path, controller, only: [:index]
      end
    end
  end
  defp many_core(model, _actions) do
    quote do
      path = Autox.Manifest.infer_collection_path(unquote(model))
      relation_path = "relationships/" <> path
      controller = Autox.Manifest.infer_relationship_controller(unquote(model))

      resources relation_path, controller, only: [:index]
    end
  end

  defmacro one(model) do
    one_core(model, @has_actions)
  end
  defmacro one(model, actions) do
    one_core(model, actions)
  end

  defp one_core(models, _actions) when is_list(models) do
    quote do
      for model <- unquote(models) do
        path = Autox.Manifest.pathify(model)
        relation_path = "relationships/" <> path
        controller = Autox.Manifest.infer_relationship_controller(model)

        resources relation_path, controller, only: [:show], singleton: true
      end
    end
  end
  defp one_core(model, _actions) do
    quote do
      path = Autox.Manifest.pathify(unquote(model))
      relation_path = "relationships/" <> path
      controller = Autox.Manifest.infer_relationship_controller(unquote(model))

      resources relation_path, controller, only: [:show], singleton: true
    end
  end
end