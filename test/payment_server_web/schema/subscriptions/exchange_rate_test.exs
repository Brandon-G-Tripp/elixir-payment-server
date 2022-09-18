defmodule PaymentServerWeb.Schema.Subscriptions.ExchangeRateTest do 
  use PaymentServerWeb.SubscriptionCase, async: true

  alias PaymentServer.ExchangeRatesMonitor.ExchangeRateRequest

  @any_exchange_rate_updated_sub_doc """
  subscription AnyExchangeRateUpdated {
    anyExchangeRateUpdated {
      fromCurrency
      toCurrency
      rate
    }
  }
  """
  describe "@anyExchangeRateUpdated" do 
    test "sends update of currency rate change with new rate", %{socket: socket} do 
      ref = push_doc socket, @any_exchange_rate_updated_sub_doc

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ExchangeRateRequest.publish_exchange_rate_change(
        %{from_currency: "CAD", to_currency: "USD", rate: "1.7"}
      )

      assert_push "subscription:data", data

      assert %{
        subscriptionId: ^subscription_id,
        result: %{
          data: %{
            "anyExchangeRateUpdated" => %{
              "fromCurrency" => _from_currency,
              "toCurrency" => _to_currency,
              "rate" => _exchange_rate
            }
          }
        }
      } = data

    end
  end


  @exchange_rate_updated_sub_doc """
  subscription ExchangeRateUpdated($currency: Currency!) {
    exchangeRateUpdated(currency: $currency) {
      fromCurrency
      toCurrency
      rate
    }
  }
  """
  
  describe "@exchangeRateUpdated" do 
    test "sends a currency update for particular currency pair", %{socket: socket} do 
      ref = push_doc socket, @exchange_rate_updated_sub_doc,
        variables: %{currency: "CAD"}

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ExchangeRateRequest.publish_exchange_rate_change(
        %{from_currency: "CAD", to_currency: "USD", rate: "2.5"}
      )

      assert_push "subscription:data", data

      assert %{
        subscriptionId: ^subscription_id,
        result: %{
          data: %{
            "exchangeRateUpdated" => %{
              "toCurrency" => "USD",
              "fromCurrency" => "CAD",
              "rate" => _exchange_rate
            }
          }
        }
      } = data
    end
  end
end
