defmodule PaymentServerWeb.Schema.Mutations.UserTest do 
  use PaymentServer.DataCase, async: true

  alias PaymentServerWeb.Schema
  alias PaymentServer.Accounts
  alias EctoShorts.Actions
  alias PaymentServer.Accounts.User

  @create_user_doc """
  mutation CreateUser (
    $email: String!,
    $name: String!
  ) {
    createUser (email: $email, name: $name) {
      email
      name
      id
      wallets {
        currency
        value
      }
    }
  }
  """

  describe "@createUser" do 
    test "creates a user" do 
      users = Accounts.all
      assert Enum.empty?(users)

      assert {:ok, %{data: data}} = Absinthe.run(@create_user_doc,
        Schema,
        variables: %{
          "email" => "test@test.com",
          "name" => "test"
        }
      )

      result = data["createUser"]
      name = result["name"]
      email = result["email"]
      id = result["id"]

      users = Accounts.all
      assert length(users) === 1

      {:ok, user} = Actions.find(User, %{id: id})

      assert name === user.name
      assert email === user.email
    end
  end
end
