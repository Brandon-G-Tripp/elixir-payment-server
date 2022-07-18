defmodule PaymentServer.Accounts.User do 
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do 
    field :email, :string
    field :name, :string

    has_many :wallets, PaymentServer.Accounts.Wallet

    timestamps()
  end

  @available_fields [:name, :email]

  def create_changeset(params) do 
    changeset(%PaymentServer.Accounts.User{}, params)
  end

  @doc false 
  def changeset(%PaymentServer.Accounts.User{} = user, attrs) do 
    user
    |> cast(attrs, @available_fields)
    |> IO.inspect(label: "user struct")
    |> validate_required(@available_fields)
    |> EctoShorts.CommonChanges.preload_changeset_assoc(:wallets)
    |> cast_assoc(:wallets)
  end
end

