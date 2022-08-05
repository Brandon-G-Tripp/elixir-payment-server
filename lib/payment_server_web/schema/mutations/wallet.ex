defmodule PaymentServerWeb.Schema.Mutations.Wallet do 
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Resolvers

  object :user_wallet_mutations do 
    field :create_wallet, :wallet do 
      arg :user_id, non_null(:id)
      arg :currency, non_null(:currency)

      resolve &Resolvers.Wallet.create_wallet/2
    end

    field :add_money, :wallet do 
      arg :user_id, non_null(:id)
      arg :currency, non_null(:currency)
      arg :deposit_amount, non_null(:float)

      resolve &Resolvers.Wallet.add_money/2
    end
  end
end
