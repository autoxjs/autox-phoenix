defmodule <%= base %>.Session do
  use <%= base %>.Web, :model
  alias <%= base %>.Repo
  alias <%= base %>.User
  use Autox.Session, 
    repo: Repo, 
    user: User
  @primary_key false
  schema "virtual:session-authentication" do
    belongs_to :user, User
    field :id, :integer
    field :email, :string
    field :password, :string, virtual: true
    field :remember_me, :boolean
    field :remember_token, :string
  end

  @create_fields ~w(email password remember_token)
  @update_fields ~w()
  @optional_fields ~w(remember_me)

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