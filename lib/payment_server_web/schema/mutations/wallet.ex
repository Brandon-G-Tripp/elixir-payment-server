defmodule PaymentServerWeb.Schema.Mutations.Wallet do 
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Resolvers

  object :user_wallet_mutations do 
    field :create_wallet, :wallet do 
      arg :user_id, non_null(:id)
      arg :currency, non_null(:string)

      resolve &Resolvers.Wallet.create_wallet/2
    end
  end
end
