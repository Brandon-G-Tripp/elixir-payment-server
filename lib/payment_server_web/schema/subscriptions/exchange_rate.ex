defmodule PaymentServerWeb.Schema.Subscriptions.ExchangeRate do 
  use Absinthe.Schema.Notation

  object :exchange_rate_subscriptions do 
    field :exchange_rate_updated, :exchange_rate do 
      arg :currency, non_null(:currency)

      config fn args, _res -> 
        {:ok, topic: "exchange_rate_updated:#{args.currency}"}
      end

    end

    field :any_exchange_rate_updated, :exchange_rate do 
      config fn _args, _res -> 
        {:ok, topic: "exchange_rate_updated:any"}
      end

    end
  end
end
