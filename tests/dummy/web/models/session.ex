defmodule Dummy.Session do
  use Dummy.Web, :model
  alias Dummy.Repo
  alias Dummy.User
  alias Dummy.Owner
  use Autox.Session, user: User, repo: Repo
  @primary_key false
  schema "virtual:session-authentication" do
    belongs_to :owner, Owner
    belongs_to :user, User
    field :id, :integer
    field :email, :string
    field :password, :string, virtual: true
    field :remember_me, :boolean
    field :remember_token, :string
  end

  @create_fields ~w(email password remember_token)
  @update_fields ~w()
  @optional_fields ~w(remember_me owner_id)

  def create_changeset(model, params\\:empty) do
    model
    |> cast(params, [], @create_fields ++ @optional_fields)
    |> validate_at_least_one(["email", "remember_token"])
    |> validate_user_authenticity
    |> cache_user_fields
    |> cache_relations([:owner])
  end

  def update_changeset(model, params\\:empty) do 
    model
    |> cast(params, [], @optional_fields)
    |> cache_relations([:owner])
  end
end