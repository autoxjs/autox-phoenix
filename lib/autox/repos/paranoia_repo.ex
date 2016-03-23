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
  def all(a,b), do: @repo.all(a,b)

  def delete!(%{__struct__: class}=model) do
    model
    |> class.delete_changeset
    |> @repo.update!
  end
  def delete!(a,b), do: @repo.delete!(a,b)

  def delete(%{__struct__: class}=model) do
    model
    |> class.delete_changeset
    |> @repo.update
  end
  def delete(a,b), do: @repo.delete(a,b)

  ## can't use defdelegate because bootstrap reasons
  def insert(a,b), do: @repo.insert(a,b)
  def insert!(a,b), do: @repo.insert!(a,b)
  def update(a,b), do: @repo.update(a,b)
  def update!(a,b), do: @repo.update!(a,b)
  def preload(a,b), do: @repo.preload(a,b)
  def preload!(a,b), do: @repo.preload!(a,b)
  def get(a,b), do: @repo.get(a,b)
  def get!(a,b), do: @repo.get!(a,b)
  def get_by(a,b), do: @repo.get_by(a,b)
  def get_by!(a,b), do: @repo.get_by!(a,b)
  def one(a,b), do: @repo.one(a,b)
  def one!(a,b), do: @repo.one!(a,b)
end