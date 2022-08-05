defmodule PaymentServer.ExchangeRatesMonitor.ExchangeRateRequest do 
  alias PaymentServer.ExchangeRatesMonitor 

  def update_rates(currencies) do 
    for from_currency <- currencies, to_currency <- currencies, from_currency !== to_currency do 
      send_request(from_currency, to_currency)
      |> convert_response
      |> ExchangeRatesMonitor.update_rates_state
    end
  end

  def send_request(from_currency, to_currency) do 
    url = "http://localhost:4001/query?function=CURRENCY_EXCHANGE_RATE&from_currency=#{from_currency}&to_currency=#{to_currency}&apikey=demo"
    case HTTPoison.get(url) do 
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> Jason.decode(body)
      {:ok, %HTTPoison.Response{status_code: 404}} -> IO.puts "Not found"
      {:error, %HTTPoison.Error{reason: reason}} -> IO.inspect reason
    end
  end


  def convert_response(resp) do 
    {:ok, resp} = resp
    %{"Realtime Currency Exchange Rate" => %{
      "1. From_Currency Code" => from_currency,
      "3. To_Currency Code" => to_currency,
      "5. Exchange Rate" => rate
    }} = resp

    ex_rate = %{
      from_currency: from_currency,
      to_currency: to_currency,
      rate: rate
    }

  end


end

