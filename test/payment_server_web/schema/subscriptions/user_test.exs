defmodule PaymentServerWeb.Schema.Subscriptions.UserTest do 
  use PaymentServerWeb.SubscriptionCase, async: true

  alias PaymentServer.Accounts

  @total_worth_change_sub_doc """
  subscription TotalWorthChange($userId: ID!, $currency: Currency!) {
    totalWorthChange(userId: $userId, currency: $currency) {
      currency
      userId
      value
    }
  }
  """

  @add_money_doc """
  mutation AddMoney($currency: Currency!, $userId: ID!, $depositAmount: Float!) {
    addMoney(currency: $currency, userId: $userId, depositAmount: $depositAmount) {
      currency 
      userId
      value
    }
  }
  """

  describe "@totalWorthChange" do 
    test "returns a wallet when worth is changed", %{socket: socket} do 
      assert {:ok, user} = Accounts.create_user(%{
        email: "test@test.com",
        name: "test"
      })

      assert {:ok, usd_wallet} = Accounts.create_wallet(%{
        currency: "USD",
        user_id: user.id
      })

      user_id = user.id

      ref = push_doc socket, @total_worth_change_sub_doc,
        variables: %{userId: user_id, currency: "USD"}

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref = push_doc socket, @add_money_doc, variables: %{
        "userId" => user_id,
        "currency" => "USD",
        "depositAmount" => 10.0
      }

      assert_reply ref, :ok, reply

      user_id_string = to_string(user_id)
    end
  end
  
end
