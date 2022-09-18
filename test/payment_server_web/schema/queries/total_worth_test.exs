defmodule PaymentServerWeb.Schema.Queries.TotalWorthTest do 
  use PaymentServer.DataCase, async: true 

  alias PaymentServerWeb.Schema
  alias PaymentServer.Accounts

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

      currency = data["totalWorth"]["currency"]
      amount = data["totalWorth"]["amount"]

      assert amount === 40.0
      assert currency === "USD"
    end
  end
end
