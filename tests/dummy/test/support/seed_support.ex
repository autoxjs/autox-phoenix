defmodule Dummy.SeedSupport do
  alias Dummy.Repo
  alias Dummy.Shop
  alias Dummy.User
  alias Dummy.Taco
  alias Dummy.Salsa
  alias Dummy.Owner
  alias Dummy.Chair
  alias Dummy.Kitchen
  alias Dummy.Session
  alias Dummy.Appointment
  alias Dummy.Batch
  alias Autox.RelationUtils, as: Ru
  import Ecto
  def owner_attributes do
    %{ "name" => "Jackson Davis Test Shop" }
  end

  def taco_attributes do
    %{"name" => "al pastor", "calories" => 9000}
  end

  def shop_attributes do
    %{"name" => "test shop","location" => "testland"}
  end

  def chair_attributes do
    %{"size" => "extra-large"}
  end

  def salsa_attributes do
    %{"name" => "Special Verde",
      "price" => 22.4,
      "secret_sauce" => "horse semen"}
  end

  def user_attributes do
    %{"email" => "dummy@test.co",
      "password" => "password123"}
  end

  def session_attributes do
    user_attributes |> Map.put("remember_me", true)
  end

  def appointment_attributes do
    %{"name" => "Test appointment",
      "material" => "failure"}
  end

  def batch_attributes do
    %{"material" => "disappointment",
      "weight" => 666}
  end

  def build_appointment do
    %Appointment{} 
    |> Appointment.create_changeset(appointment_attributes) 
    |> Repo.insert!
  end

  def build_import_batch(appointment) do
    appointment
    |> build_assoc(:import_batches)
    |> Batch.create_changeset(batch_attributes) 
    |> Repo.insert!
  end

  def build_export_batch(appointment) do
    appointment
    |> build_assoc(:export_batches)
    |> Batch.create_changeset(batch_attributes) 
    |> Repo.insert!
  end

  def build_session do
    %Session{}
    |> Session.create_changeset(session_attributes)
    |> Repo.insert!
  end

  def build_user do
    %User{}
    |> User.create_changeset(user_attributes)
    |> Repo.insert!
  end

  def build_chair do
    %Chair{}
    |> Chair.create_changeset(chair_attributes)
    |> Repo.insert!
  end

  def build_chair(shop) do
    shop
    |> build_assoc(:chairs)
    |> Chair.create_changeset(chair_attributes)
    |> Repo.insert!
  end

  def build_kitchen do
    %Kitchen{}
    |> Kitchen.create_changeset(%{})
    |> Repo.insert!
  end

  def build_kitchen(shop) do
    shop
    |> build_assoc(:kitchen)
    |> Kitchen.create_changeset(%{})
    |> Repo.insert!
  end

  def build_owner do
    %Owner{}
    |> Owner.create_changeset(owner_attributes)
    |> Repo.insert!
  end

  def build_shop do
    %Shop{}
    |> Shop.create_changeset(shop_attributes)
    |> Repo.insert!
  end

  def build_shop(owner) do
    owner
    |> build_assoc(:shops)
    |> Shop.create_changeset(shop_attributes)
    |> Repo.insert!
  end

  def build_salsa do
    %Salsa{}
    |> Salsa.create_changeset(salsa_attributes)
    |> Repo.insert!
  end

  def build_taco do
    %Taco{}
    |> Taco.create_changeset(taco_attributes)
    |> Repo.insert!
  end

  def salsa_to_shop(salsa, shop) do
    params = %{"id" => salsa.id, "type" => "salsas", "attributes" => %{"authorization_key" => "rover doge"}}
    {:insert, changeset} = Ru.caac(Repo, shop, :salsas, params)
    changeset 
    |> Repo.insert! 
    |> Repo.preload([:salsa, :shop])
  end
end