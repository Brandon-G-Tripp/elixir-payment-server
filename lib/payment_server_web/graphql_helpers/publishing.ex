defmodule  PaymentServerWeb.GraphqlHelpers.Publishing do 
  def publish_total_worth_change(wallet) do 
    Absinthe.Subscription.publish(
      PaymentServerWeb.Endpoint,
      wallet,
      total_worth_change: "total_worth_change:#{wallet.user_id}/#{wallet.currency}"
    )
  end

  def publish_exchange_rate_change(
    %{from_currency: from, rate: _rate, to_currency: _to} = exchange_rate
  ) do 
    {_, exchange_rate} = Map.get_and_update(exchange_rate, :rate, fn current_val -> 
      {current_val, String.to_float(current_val)}
    end)

    Absinthe.Subscription.publish(
      PaymentServerWeb.Endpoint,
      exchange_rate, 
      exchange_rate_updated: "exchange_rate_updated:#{from}"
    )

    Absinthe.Subscription.publish(
      PaymentServerWeb.Endpoint,
      exchange_rate,
      any_exchange_rate_updated: "exchange_rate_updated:any"
    )

    exchange_rate
  end
end
