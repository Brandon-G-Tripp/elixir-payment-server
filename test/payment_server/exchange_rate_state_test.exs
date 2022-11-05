defmodule PaymentServer.ExchangeRatesMonitor.ExchangeRateStateTest do 
  use ExUnit.Case, async: true

  alias PaymentServer.ExchangeRatesMonitor.ExchangeRateState


  describe "&get_exchange_rate/3" do 
    test "gets exchange rate for specified currency pair" do 
      ExchangeRateState.update_exchange_rate(
        %{to_currency: "USD", from_currency: "CAD", rate: 1.5}
      )
      exchange_rate = ExchangeRateState.get_exchange_rate(
        "CAD",
        "USD"
      ) 

      assert %{to_currency: "USD", from_currency: "CAD", rate: 1.5} === exchange_rate

      exchange_rate = ExchangeRateState.get_exchange_rate(
        "USD",
        "CAD"
      ) 

      assert %{to_currency: "CAD", from_currency: "USD", rate: 2.3} === exchange_rate
    end
  end

  describe "&update_rates_state/2" do 
    test "returns a no reply tuple when called with a valid currency" do 
      ExchangeRateState.update_exchange_rate(%{
        from_currency: "CAD",
        to_currency: "USD",
        rate: 2.1
      })

      exchange_rate = ExchangeRateState.get_exchange_rate("CAD", "USD")

      assert %{from_currency: "CAD", to_currency: "USD", rate: 2.1} = exchange_rate
    end
  end

end
