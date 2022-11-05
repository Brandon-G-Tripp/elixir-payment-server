defmodule PaymentServer.ExchangeRatesMonitor do 
  use GenServer

  alias PaymentServer.ExchangeRatesMonitor
  alias PaymentServer.ExchangeRatesMonitor.ExchangeRateRequest
  alias PaymentServer.ExchangeRatesMonitor.ExchangeRateState

  @default_name ExchangeRatesMonitor
  @available_currencies ["USD", "CAD", "MXN", "GBP"]

  # Client

  def start_link(opts \\ []) do 
    state = Keyword.get(opts, :state, @available_currencies)
    opts = Keyword.put_new(opts, :name, @default_name)

    GenServer.start_link(ExchangeRatesMonitor, state, opts)
  end

  # Server

  @impl true
  def init(currencies) do 
    schedule_exchange_rate_update()
    {:ok, currencies}
  end

  @impl true
  def handle_info(:work, currencies) do 
    # call api here
    ExchangeRatesMonitor.update_rates(@available_currencies)
    schedule_exchange_rate_update()
    {:noreply, currencies}
  end

  # Private Functions

  defp schedule_exchange_rate_update do 
    Process.send_after(self(), :work, 5000)
  end
  
  def update_rates(currencies) do 
    for from_currency <- currencies, to_currency <- currencies, from_currency !== to_currency do 
      {from_currency, to_currency}
      |> ExchangeRateRequest.update_rate
      |> ExchangeRateState.update_exchange_rate
    end
  end

end
