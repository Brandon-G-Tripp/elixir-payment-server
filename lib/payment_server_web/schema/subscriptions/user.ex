defmodule PaymentServerWeb.Schema.Subscriptions.User do 
  use Absinthe.Schema.Notation

  object :user_subscriptions do 
    field :total_worth_change, :wallet do 
      arg :user_id, non_null(:id)
      arg :currency, non_null(:currency)
      
      config fn args, _res -> 
        {:ok, topic: "total_worth_change:#{args.user_id}/#{args.currency}"}
      end

      trigger :add_money, topic: fn _ ->
        "money_added"
      end

      resolve fn balance, _args, _res -> {:ok, balance} end
    end
    # field :total_worth_change, :wallet do 
    #   arg :user_id, non_null(:id)

    #   config fn args, _res -> 
    #     {:ok, topic: "user_total_worth_change:#{args.user_id}"}
    #   end

    #   resolve fn wallet, _args, _res -> 
    #     {:ok, wallet}
    #   end

    #   trigger :add_money, topic: fn wallet -> 
    #     "a wallet"
    #   end

    # end

    # field :money_added_by_user, :wallet do 
    #   arg :user_id, non_null(:id)

    #   config fn args, _res -> 
    #     {:ok, topic: "money_added_by_user:#{args.user_id}"}
    #   end

    #   trigger :add_money, topic: fn wallet ->
    #     wallet
    #   end
    #
    # end

  end
end
