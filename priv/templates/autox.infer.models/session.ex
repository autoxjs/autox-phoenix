defmodule <%= base %>.Session do
  use <%= base %>.Web, :model
  alias <%= base %>.Repo
  alias <%= base %>.User
  use Autox.Session, 
    repo: Repo, 
    user: User
  schema "sessions" do
    belongs_to :user, User
    field :password, :string, virtual: true
    field :remember_me, :boolean, virtual: true
    field :email, :string
    field :remember_token, :string
    timestamps
  end

  @create_fields ~w(email password remember_token)
  @update_fields ~w()
  @optional_fields ~w(remember_me)
  @preload_fields ~w(user)a

  def preload_fields, do: @preload_fields
  def create_changeset(model, params\\:empty) do
    model
    |> cast(params, [], @create_fields ++ @optional_fields)
    |> validate_at_least_one(["email", "remember_token"])
    |> validate_user_authenticity
    |> cache_user_fields
  end

  def update_changeset(model, params\\:empty) do 
    model
    |> cast(params, [], @update_fields)
    |> cache_relations([])
  end

end