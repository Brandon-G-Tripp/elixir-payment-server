defmodule PaymentServerWeb.Resolvers.User do 
  alias PaymentServer.Accounts

  def find(%{id: id}, _) do 
    id = String.to_integer(id)
    Accounts.find(%{id: id})
  end

  def all(_params, _) do 
    users = Accounts.all
    {:ok, users}
  end

  def create_user(params, _) do 
    Accounts.create_user(params)
  end
end
