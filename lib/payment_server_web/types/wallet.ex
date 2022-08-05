defmodule PaymentServerWeb.Types.Wallet do 
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  @desc "Preferences for user"
  object :wallet do 
    field :currency, :string
    field :value, :float
    field :user_id, :id

    field :user, :user, resolve: dataloader(PaymentServer.Accounts, :user)
  end
end
