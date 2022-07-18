defmodule PaymentServerWeb.Schema.Queries.UserWallet do 
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Resolvers

  object :user_wallet_queries do 
    field :wallets, list_of(:user_wallet) do 
      arg :user_id, non_null(:id)

      resolve &Resolvers.UserWallet.all_user_wallets/2
    end

    field :wallet_by_currency, :user_wallet do 
      arg :user_id, non_null(:id)
      arg :currency, :string

      resolve &Resolvers.UserWallet.find_user_wallet_by_currency/2
    end
  end

end
