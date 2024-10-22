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
      arg :deposit_amount, non_null(:integer)

      resolve &Resolvers.Wallet.add_money/2
    end

    field :send_money, :wallet do 
      arg :sending_user_id, non_null(:id)
      arg :receiving_user_id, non_null(:id)
      arg :sender_currency, non_null(:currency)
      arg :receiver_currency, non_null(:currency)
      arg :amount, non_null(:integer)

      resolve &Resolvers.Wallet.send_money/2
    end
  end
end
