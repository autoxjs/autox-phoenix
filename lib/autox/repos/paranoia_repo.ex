defmodule Autox.ParanoiaRepo do
  import Ecto.Query, only: [from: 2, where: 3]
  @moduledoc """
  Paranoid Repos update a field called "deleted_at" instead of deleting
  In addition, all queries get a deleted_at filter
  """
  @repo Autox.default_repo

  def all(module) when is_atom(module) do
    query = from x in module, select: x
    all(query)
  end
  def all(queryable) do
    queryable |> where([x], is_nil(x.deleted_at)) |> @repo.all
  end

  def delete(%{__struct__: class}=model) do
    model
    |> class.delete_changeset
    |> @repo.update
  end

  defdelegate [insert(a,b), update(a,b), preload(a,b), get(a,b), get_by(a,b), one(a,b), all(a,b), delete(a,b)], to: @repo
end