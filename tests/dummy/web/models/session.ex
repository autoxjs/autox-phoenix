defmodule Dummy.Session do
  use Dummy.Web, :model
  alias Dummy.Owner
  alias Dummy.User
  alias Dummy.Repo
  use Autox.Session, 
    user: User, 
    repo: Repo
  
  schema "sessions" do
    belongs_to :owner, Owner
    belongs_to :user, User
    field :password, :string, virtual: true
    field :remember_me, :boolean, virtual: true
    field :email, :string
    field :remember_token, :string
    timestamps
  end

  @create_fields ~w(email password remember_token)
  @update_fields ~w()
  @optional_fields ~w(remember_me owner_id)
  @preload_fields ~w(owner user)a

  def preload_fields, do: @preload_fields
  def create_changeset(model, params\\%{}) do
    model
    |> cast(params, [], @create_fields ++ @optional_fields)
    |> validate_at_least_one(["email", "remember_token"])
    |> validate_user_authenticity
    |> cache_user_fields
  end

  def update_changeset(model, params\\%{}) do 
    model
    |> cast(params, [], @optional_fields)
  end
end