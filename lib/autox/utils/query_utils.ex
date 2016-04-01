defmodule Autox.QueryUtils do
  @moduledoc """
  Helper functions for handling queryparams based upon jsonapi specs
  http://jsonapi.org/format/#fetching-sorting

  includes and sparse fields aren't supported (because fuck optimization)
  """
  import Ecto.Query
  def construct(class, params) do
    from(x in class, select: x)
    |> consider_sorting(params)
    |> consider_filtering(params)
    |> consider_pagination(params)
  end

  def meta(class, params) do
    from(x in class, select: count(x.id, :distinct))
    |> consider_filtering(params)
  end

  @doc """
  Looks for a "filter" key in your params
  filter[golive_at]===today
  filter[golive_at]=!=today
  filter[golive_at]=<=today
  filter[golive_at]=<today
  filter[golive_at]=>=today
  in generatel, the "operator" comes after the equal sign
  """
  def consider_filtering(class, key, opval) when is_binary(opval) do
    key = key |> String.to_existing_atom
    case opval do
      "==null"   -> class |> where([x], is_nil(field(x, ^key)))
      "=="<>val  -> class |> where([x], field(x, ^key) == ^val)
      "!=null"   -> class |> where([x], not(is_nil(field(x, ^key))))
      "!="<>val  -> class |> where([x], field(x, ^key) != ^val)
      "<="<>val  -> class |> where([x], field(x, ^key) <= ^val)
      ">="<>val  -> class |> where([x], field(x, ^key) >= ^val)
      "!<"<>val  -> class |> where([x], not(field(x, ^key) < ^val))
      "<"<>val   -> class |> where([x], field(x, ^key) < ^val)
      "!>"<>val  -> class |> where([x], not(field(x, ^key) > ^val))
      ">"<>val   -> class |> where([x], field(x, ^key) > ^val)
      "~"<>val   -> class |> where([x], like(field(x, ^key), ^("%"<>val<>"%")))
      "i~"<>val  -> class |> where([x], ilike(field(x, ^key), ^("%"<>val<>"%")))
      val when is_binary(val) ->
        class |> where([x], field(x, ^key) in ^String.split(val, ","))
    end
  end
  def consider_filtering(class, key, [opval|opvals]) do
    class |> consider_filtering(key, opval) |> consider_filtering(key, opvals)
  end
  def consider_filtering(class, _, _), do: class
  def consider_filtering(class, [{key, opvals}|filters]) do
    class |> consider_filtering(key, opvals) |> consider_filtering(filters)
  end
  def consider_filtering(class, %{"filter" => filters}) do
    class |> consider_filtering(filters |> Map.to_list)
  end
  def consider_filtering(class, _), do: class


  @doc """
  Looks for a "sort" in your params
  -created_at,name
  """
  def consider_sorting(class, "-" <> name) do
    key = name |> String.to_existing_atom
    class |> order_by([x], [desc: field(x, ^key)])
  end
  def consider_sorting(class, name) when is_binary(name) do
    key = name |> String.to_existing_atom
    class |> order_by([x], [asc: field(x, ^key)])
  end
  def consider_sorting(class, [name|names]) do
    class |> consider_sorting(name) |> consider_sorting(names)
  end
  def consider_sorting(class, %{"sort" => names}) when is_list(names) do
    class |> consider_sorting(names)
  end
  def consider_sorting(class, %{"sort" => names}) when is_binary(names) do
    class |> consider_sorting(names |> String.split(","))
  end
  def consider_sorting(class, _), do: class

  @doc """
  Looks for a "page" key in your params
  supports 'offset' and 'limit'
  """
  def consider_pagination(class, "limit", value), do: class |> limit(^value)
  def consider_pagination(class, "offset", value), do: class |> offset(^value)
  def consider_pagination(class, [{key, value}|pages]) do
    class |> consider_pagination(key, value) |> consider_pagination(pages)
  end
  def consider_pagination(class, %{"page" => page}) do
    consider_pagination(class, page |> Map.to_list)
  end
  def consider_pagination(class, _), do: class
end