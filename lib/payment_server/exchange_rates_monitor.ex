defmodule PaymentServer.ExchangeRatesMonitor do 
  use GenServer

  alias PaymentServer.ExchangeRatesMonitor
  alias PaymentServer.ExchangeRatesMonitor.ExchangeRateRequest

  @default_name ExchangeRatesMonitor
  @available_currencies ["USD", "CAD", "MXN", "GBP"]

  # Client

  def start_link(opts \\ []) do 
    state = Keyword.get(opts, :state, %{})
    opts = Keyword.put_new(opts, :name, @default_name)

    GenServer.start_link(ExchangeRatesMonitor, state, opts)
  end

  def update_rates_state(ex_rate, server \\ @default_name) do 
    GenServer.cast(server, {:update_rate, ex_rate})
  end

  def get_exchange_rate(from_currency, to_currency, server \\ @default_name) do 
    GenServer.call(server, {:get_exchange_rate, from_currency, to_currency})
  end

  # Server

  @impl true
  def init(state) do 
    schedule_exchange_rate_update()
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do 
    # call api here
    ExchangeRateRequest.update_rates(@available_currencies)
    schedule_exchange_rate_update()
    {:noreply, state}
  end

  @impl true
  def handle_cast({:update_rate, ex_rate}, state) do
    %{from_currency: from_currency, to_currency: to_currency, rate: _rate} = ex_rate
    res = Map.put(state, "#{from_currency}/#{to_currency}", ex_rate)
    {:noreply, res}
  end

  @impl true
  def handle_call({:get_exchange_rate, from_currency, to_currency}, _from, state) do 
    res = Map.get(state, "#{from_currency}/#{to_currency}")
    {:reply, res, state}
  end

  # Private Functions

  defp schedule_exchange_rate_update() do 
    Process.send_after(self(), :work, 5000)
  end
end
