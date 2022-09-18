defmodule PaymentServer.ExchangeRatesMonitorTest do 
  use ExUnit.Case, async: true

  alias PaymentServer.ExchangeRatesMonitor

  setup do 
    {:ok, pid} = ExchangeRatesMonitor.start_link(name: nil)

    %{pid: pid}
  end

  describe "&update_rates_state/2" do 
    test "returns a no reply tuple when called with a valid currency", %{pid: pid} do 

    end
  end

  describe "&get_exchange_rate/3" do 
  end

  describe "&get_all_rates/1" do 
  end

end
