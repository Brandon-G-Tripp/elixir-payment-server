defmodule PaymentServer.Accounts.Wallet do 
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallets" do 
    field :currency, :string
    field :value, :integer

    belongs_to :user, PaymentServer.Accounts.User
  end

  @available_fields [:currency, :user_id]

  def create_changeset(params) do 
    changeset(%PaymentServer.Accounts.Wallet{}, params)
  end

  def changeset(wallet, attrs) do 
    wallet 
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
  end
end
