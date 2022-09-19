defmodule PaymentServer.ExchangeRatesMonitorTest do 
  use ExUnit.Case, async: true

  alias PaymentServer.ExchangeRatesMonitor

  setup do 
    {:ok, pid} = ExchangeRatesMonitor.start_link(name: nil)

    %{pid: pid}
  end

  describe "&get_exchange_rate/3" do 
    test "gets exchange rate for specified currency pair", %{pid: _pid} do 
      ExchangeRatesMonitor.update_rates_state(
        %{to_currency: "USD", from_currency: "CAD", rate: 1.5}
      )
      exchange_rate = ExchangeRatesMonitor.get_exchange_rate(
        "CAD",
        "USD"
      ) 

      assert %{to_currency: "USD", from_currency: "CAD", rate: 1.5} === exchange_rate

      exchange_rate = ExchangeRatesMonitor.get_exchange_rate(
        "USD",
        "CAD"
      ) 

      assert %{to_currency: "CAD", from_currency: "USD", rate: 2.3} === exchange_rate
    end
  end

  describe "&update_rates_state/2" do 
    test "returns a no reply tuple when called with a valid currency", %{pid: _pid} do 
      ExchangeRatesMonitor.update_rates_state(%{
        from_currency: "CAD",
        to_currency: "USD",
        rate: 2.1
      })

      exchange_rate = ExchangeRatesMonitor.get_exchange_rate("CAD", "USD")

      assert %{from_currency: "CAD", to_currency: "USD", rate: 2.1} = exchange_rate
    end
  end


  describe "&get_all_rates/1" do 
    test "get list of exchange rates", %{pid: _pid} do 
      exchange_rate_map = ExchangeRatesMonitor.get_all_rates

      assert Map.has_key?(exchange_rate_map, "CAD/USD")
      assert Map.has_key?(exchange_rate_map, "USD/CAD")

    end
  end

end
