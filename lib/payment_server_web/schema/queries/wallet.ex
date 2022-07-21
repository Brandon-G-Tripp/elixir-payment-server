defmodule PaymentServerWeb.Schema.Queries.Wallet do 
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Resolvers

  object :user_wallet_queries do 
    field :wallets, list_of(:wallet) do 
      arg :user_id, non_null(:id)

      resolve &Resolvers.Wallet.all_wallets/2
    end

    field :wallet_by_currency, :wallet do 
      arg :id, :id
      arg :user_id, non_null(:id)
      arg :currency, :currency

      resolve &Resolvers.Wallet.find_wallet_by_currency/2
    end
  end

end
