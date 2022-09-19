defmodule PaymentServerWeb.Schema.Queries.TotalWorthTest do 
  use PaymentServer.DataCase, async: true 

  alias PaymentServerWeb.Schema
  alias PaymentServer.Accounts
  alias PaymentServer.ExchangeRatesMonitor

  @total_worth_doc """
  query TotalWorth($currency: Currency!, $userId: ID!) {
    totalWorth(currency: $currency, userId: $userId) {
      amount
      currency
      timestamp
    }
  }
  """

  describe "@total_worth" do 
    test "fetch the total worth of User in one currency" do 
      assert {:ok, user} = Accounts.create_user(%{
        email: "test@test.com",
        name: "tester"
      })

      assert {:ok, _wallet_usd} = Accounts.create_wallet(%{
        currency: "USD",
        user_id: user.id
      })

      assert {:ok, _wallet_cad} = Accounts.create_wallet(%{
        currency: "CAD",
        user_id: user.id
      })

      assert {:ok, _wallet_amount_usd} = Accounts.add_money(%{
        currency: "USD",
        user_id: user.id,
        deposit_amount: 10.0
      })

      assert {:ok, _wallet_amount_cad} = Accounts.add_money(%{
        currency: "CAD",
        user_id: user.id,
        deposit_amount: 20.0
      })

      assert {:ok,  %{data: data} } = Absinthe.run(@total_worth_doc, Schema,
        variables: %{
          "userId" => user.id,
          "currency" => "USD"
        }
      )

      %{from_currency: _, to_currency: _, rate: exchange_rate}= ExchangeRatesMonitor.get_exchange_rate("CAD", "USD")

      expected_wallet_sum = 10.0 + (20.0 * exchange_rate)

      currency = data["totalWorth"]["currency"]
      amount = data["totalWorth"]["amount"]

      assert amount === expected_wallet_sum
      assert currency === "USD"
    end
  end
end
