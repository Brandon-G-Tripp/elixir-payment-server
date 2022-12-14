defmodule PaymentServer.ExchangeRatesMonitor.ExchangeRateState do 
  use Agent
  

  @initial_test_rates %{
    "CAD/USD" => %{
      from_currency: "CAD",
      to_currency: "USD",
      rate: 1.5
    },
    "USD/CAD" => %{
      from_currency: "USD",
      to_currency: "CAD",
      rate: 2.3
    }
  }

  def start_link(_opts) do 
    Agent.start_link(fn -> @initial_test_rates end, name: __MODULE__)
  end

  def update_exchange_rate(ex_rate) do 
    %{
      from_currency: from_currency,
      to_currency: to_currency,
      rate: _rate
    } = ex_rate

    Agent.update(__MODULE__, &Map.put(
      &1, "#{from_currency}/#{to_currency}", ex_rate)
    )

    ex_rate
  end

  def get_exchange_rate(from_currency, to_currency) do 
    Agent.get(__MODULE__, &Map.get(&1, "#{from_currency}/#{to_currency}"))
  end

  def get_all_rates do 
    Agent.get(__MODULE__, & &1)
  end

end
