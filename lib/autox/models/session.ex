defmodule Autox.Session do
  import Ecto.Changeset

  def cache_user_fields(%{valid?: false}=x), do: x
  def cache_user_fields(changeset) do
    %{remember_token: token, email: email, id: user_id} = changeset 
    |> get_field(:user) 
    changeset 
    |> put_change(:remember_token, token)
    |> put_change(:email, email)
    |> put_change(:user_id, user_id)
    |> delete_change(:user)
  end

  def validate_authenticity(changeset, nil), do: changeset |> add_error(:email, "no such user")
  def validate_authenticity(changeset, user) do
    password = changeset |> get_field(:password, "")
    case Comeonin.Bcrypt.checkpw(password, user.password_hash) do
      true -> changeset |> put_change(:user, user)
      _ -> changeset |> add_error(:password, "wrong password")
    end
  end

  def validate_existence(changeset, nil) do
    changeset |> add_error(:remember_token, "invalid token")
  end
  def validate_existence(changeset, user) do
    changeset |> put_change(:user, user)
  end

  def validate_at_least_one(changeset, fields), do: validate_at_least_one(changeset, fields, [])
  defp validate_at_least_one(changeset, [], missing_fields) do 
    changeset |> cast(%{}, missing_fields)
  end
  defp validate_at_least_one(changeset, [field|fields], missing_fields) do
    changeset 
    |> get_field(field |> String.to_existing_atom)
    |> case do
      nil -> validate_at_least_one(changeset, fields, [field|missing_fields])
      _ -> changeset
    end
  end

  defmacro __using__(opts) do
    repo = opts[:repo] || Mix.Phoenix.base |> Module.safe_concat("Repo")
    user = opts[:user] || Mix.Phoenix.base |> Module.safe_concat("User")
    quote location: :keep do
      import Autox.Session
      def validate_user_authenticity(%{valid?: false}=c), do: c
      def validate_user_authenticity(changeset) do
        email = changeset |> get_field(:email)
        token = changeset |> get_field(:remember_token)
        case {email, token} do
          {nil, nil} ->
            changeset
            |> add_error(:email, "cannot be blank without a remember token")
          {email, _} when is_binary(email) -> 
            user = unquote(repo).get_by(unquote(user), email: email)
            changeset |> validate_authenticity(user)
          {_, token} when is_binary(token) ->
            user = unquote(repo).get_by(unquote(user), remember_token: token)
            changeset |> validate_existence(user)
        end
      end

      def cache_relations(changeset, []), do: changeset
      def cache_relations(changeset, [key|keys]) when is_atom(key) do
        %{related: class, owner_key: field} = __MODULE__.__schema__(:association, key)

        changeset
        |> get_field(field)
        |> case do
          nil -> {:done, changeset}
          id -> {:ok, id}
        end
        |> case do
          {:ok, id} -> {:ok, class |> unquote(repo).get(id)}
          other -> other
        end
        |> case do
          {:ok, nil} -> changeset |> add_error(field, "no such model")
          {:ok, model} -> changeset |> put_change(key, model)
          {:done, changeset} -> changeset
        end
        |> cache_relations(keys)
      end
    end
  end
end