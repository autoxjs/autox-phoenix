defmodule <%= base %>.User do
  use <%= base %>.Web, :model
  import Autox.User
  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :recovery_hash, :string
    field :remember_token, :string
    field :forget_at, Ecto.DateTime

    timestamps
  end

  @creation_fields ~w(email password)
  @updative_fields ~w(password)
  @optional_fields ~w()
  @password_hash_opts [min_length: 1]

  def create_changeset(model, params\\:empty) do
    model
    |> cast(params, @creation_fields, @optional_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: @password_hash_opts[:min_length])
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> prepare_changes(&encrypt_password/1)
    |> prepare_changes(&setup_remember_token/1)
  end

  def update_changeset(model, params\\:empty) do
    model
    |> cast(params, @updative_fields, @optional_fields)
  end

end