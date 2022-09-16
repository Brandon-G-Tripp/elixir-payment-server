defmodule PaymentServerWeb.Schema.Queries.UserTest do 
  use PaymentServer.DataCase, async: true

  alias PaymentServerWeb.Schema
  alias PaymentServer.Accounts


  @all_user_doc """
  query AllUsers {
    users {
      email
      id
      name
      wallets {
        currency
        value
      }
    }
  }
  """

  describe "@users" do 
    test "fetches list of users" do 
      assert {:ok, user} = Accounts.create_user(%{
        email: "test@test.com",
        name: "tester1",
      })

      assert {:ok, _user2} = Accounts.create_user(%{
        email: "test2@test.com",
        name: "tester2",
      })

      assert {:ok, %{data: data}} = Absinthe.run(@all_user_doc, Schema)

      assert List.first(data["users"])["id"] === to_string(user.id)
    end
  end

  @user_by_id_doc """
  query UserById($id: ID!) {
    user(id: $id) {
      id
      name
      email
    }
  }
  """

  describe "@user" do 
    test "fetch a single user by id" do 
      assert {:ok, user} = Accounts.create_user(%{
        email: "test@test.com",
        name: "tester"
      })

      assert {:ok, %{data: data}} = Absinthe.run(@user_by_id_doc, Schema,
        variables: %{
          "id" => to_string(user.id)
        }
      )

      assert data["user"]["id"] === to_string(user.id)
    end
  end
end
