defmodule PaymentServerWeb.Schema.Mutations.WalletTest do 
  use PaymentServer.DataCase, async: true

  alias PaymentServerWeb.Schema
  alias PaymentServer.Accounts
  alias EctoShorts.Actions

  @create_wallet_doc """
  mutation CreateWallet ($currency: Currency!, $userId: ID!) {
    createWallet(currency: $currency, userId: $userId) {
      userId
      currency
      value
    }
  }
  """

  describe "@createWallet" do 
    test "creates a wallet linked to a user" do 
      assert {:ok, user} = Accounts.create_user(%{
        email: "test@test.com",
        name: "test"
      })

      assert {:ok, %{data: data}} = Absinthe.run(@create_wallet_doc, Schema,
        variables: %{
          "currency" => "USD",
          "userId" => user.id
        }
      )

      currency = data["createWallet"]["currency"]
      user_id = data["createWallet"]["userId"]

      assert currency === "USD"
      assert String.to_integer(user_id) === user.id
    end
  end
end
