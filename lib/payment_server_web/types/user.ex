defmodule PaymentServerWeb.Types.User do 
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  import_types PaymentServerWeb.Types.Wallet

  @desc "A user that has wallets"
  object :user do 
    field :id, :id
    field :name, :string
    field :email, :string
    field :wallets, list_of(:wallet), resolve: dataloader(PaymentServer.Accounts, :wallets)
  end

  @desc "User wallet input"
  input_object :wallet_input do 
    field :currency, :string
    field :value, :integer
  end
end
