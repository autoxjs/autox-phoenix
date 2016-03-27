defmodule Autox.User do
  import Ecto.Changeset
  def encrypt_password(changeset) do
    password_hash = changeset
    |> get_field(:password)
    |> Comeonin.Bcrypt.hashpwsalt

    changeset
    |> put_change(:password_hash, password_hash)
  end

  def setup_remember_token(changeset) do
    {:changes, email} = changeset |> fetch_field(:email)
    {:changes, hash} = changeset |> fetch_field(:password_hash)

    changeset |> remember_me_core(email, hash)
  end

  def remember_me_core(changeset, email, password) do
    key = "#{email}-#{password}"
    {x,y,z} = :os.timestamp
    salt = "#{x}-#{y}-#{z}"
    token = :sha256 |> :crypto.hmac(key, salt) |> Base.encode64
    date = Ecto.DateTime.utc |> Map.update(:year, 3000, &(&1 + 5))
    changeset
    |> put_change(:remember_token, token)
    |> put_change(:forget_at, date)
  end
end