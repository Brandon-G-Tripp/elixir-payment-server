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
  mutation AddMoney($currency: Currency!, $userId: ID!, $depositAmount: Int!) {
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

      assert {:ok, _usd_wallet} = Accounts.create_wallet(%{
        currency: "USD",
        user_id: user.id
      })

      updated_wallet_amount = 10
      user_id = user.id

      ref = push_doc socket, @total_worth_change_sub_doc,
        variables: %{userId: user_id, currency: "USD"}

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref = push_doc socket, @add_money_doc, variables: %{
        "userId" => user_id,
        "currency" => "USD",
        "depositAmount" => 10
      }

      assert_reply ref, :ok, reply

      user_id_string = to_string(user_id)

      assert %{
        data: %{"addMoney" => %{
          "currency" => "USD",
          "userId" => ^user_id_string,
          "value" => ^updated_wallet_amount
        }}
      } = reply

      assert_push "subscription:data", data

      assert %{
        subscriptionId: ^subscription_id,
        result: %{
          data: %{
            "totalWorthChange" => %{
              "userId" => ^user_id_string,
              "currency" => "USD",
              "value" => _value
            }
          }
        }
      } = data
      
      assert {:ok, wallet} = Accounts.find_wallet_by_currency(%{currency: "USD", user_id: user.id})

      assert wallet.value === updated_wallet_amount

    end
  end
  
end
