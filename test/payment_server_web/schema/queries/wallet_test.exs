defmodule PaymentServerWeb.Schema.Queries.WalletTest do 
  use PaymentServer.DataCase, async: true

  alias PaymentServerWeb.Schema
  alias PaymentServer.Accounts


  @all_user_wallets_doc """
  query AllUserWallets($userId: ID!) {
    wallets(userId: $userId) {
      currency
      userId
      value
    }
  }
  """

  describe "@wallets" do 
    test "fetch all wallets for user" do 
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

      assert {:ok, %{data: data}} = Absinthe.run(@all_user_wallets_doc, Schema,
        variables: %{
          "userId" => user.id
        }
      )

      [first_wallet | rest] = data["wallets"]
      [second_wallet | _rest] = rest

      assert String.to_integer(first_wallet["userId"]) == user.id
      assert String.to_integer(second_wallet["userId"]) == user.id
    end
  end

  @wallet_by_currency_doc """
  query WalletByCurrency($currency: Currency!, $userId: ID!) {
    walletByCurrency(currency: $currency, userId: $userId) {
      currency
      userId
      value
    }
  }
  """

  describe "@wallet_by_currency" do 
    test "retrieves a wallet from particular user based off currency" do 
      assert {:ok, user} = Accounts.create_user(%{
        email: "test@test.com",
        name: "tester"
      })

      assert {:ok, _wallet} = Accounts.create_wallet(%{
        user_id: user.id,
        currency: "USD"
      })

      assert {:ok, _wallet2} = Accounts.create_wallet(%{
        user_id: user.id,
        currency: "CAD"
      })

      assert {:ok, %{data: data}} = Absinthe.run(@wallet_by_currency_doc, Schema,
        variables: %{
          "userId" => to_string(user.id),
          "currency" => "USD"
        }
      )

      wallet_currency = data["walletByCurrency"]["currency"]
      wallet_user_id = data["walletByCurrency"]["userId"]

      assert wallet_currency === "USD" 
      assert wallet_user_id === to_string(user.id)

    end
  end
end
