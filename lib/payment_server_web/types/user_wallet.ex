defmodule PaymentServerWeb.Types.UserWallet do 
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "Preferences for user"
  object :user_wallet do 
    field :currency, :string
    field :value, :integer
    field :user_id, :id

    field :user, :user, resolve: dataloader(PaymentServer.Accounts, :user)
  end
end
