defmodule PaymentServerWeb.Schema.Mutations.UserWallet do 
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Resolvers

  object :user_wallet_mutations do 
    field :create_user_wallet, :user_wallet do 
      arg :user_id, non_null(:id)
      arg :currency, non_null(:string)

      resolve &Resolvers.UserWallet.create_user_wallet/2
    end
  end
end
