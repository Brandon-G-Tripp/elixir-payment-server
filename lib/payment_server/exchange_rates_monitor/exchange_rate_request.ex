defmodule PaymentServer.ExchangeRatesMonitor.ExchangeRateRequest do 
  alias PaymentServerWeb.GraphqlHelpers.Publishing

  def update_rate(currency_pair) do 
    case send_request(currency_pair) do 
      {:ok, rate} ->
        rate
        |> convert_response
        |> Publishing.publish_exchange_rate_change
      {:error, message} ->
        message
    end
  end

  def send_request({from_currency, to_currency}) do 
    url = "http://localhost:4001/query?function=CURRENCY_EXCHANGE_RATE&from_currency=#{from_currency}&to_currency=#{to_currency}&apikey=demo"
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url),
         {:ok, resp_body} <- Jason.decode(body) do
      {:ok, resp_body}
    else
      error -> error
    end
  end


  def convert_response(resp) do 
    %{"Realtime Currency Exchange Rate" => %{
      "1. From_Currency Code" => from_currency,
      "3. To_Currency Code" => to_currency,
      "5. Exchange Rate" => rate
    }} = resp

   %{
      from_currency: from_currency,
      to_currency: to_currency,
      rate: rate
    }
  end

end

