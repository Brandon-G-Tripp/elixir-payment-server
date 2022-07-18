defmodule PaymentServerWeb.Resolvers.UserWallet do 
  alias PaymentServer.Accounts

  
  def create_user_wallet(params, _) do 
    Accounts.create_user_wallet(params)
  end

  def find_user_wallet_by_currency(%{id: id, currency: currency}, _) do 
    id = String.to_integer(id)
    user = Accounts.find_user_wallet_by_currency(%{id: id, currency: currency})

  end

  def all_user_wallets(params, _) do 
    IO.inspect(params, label: "params in all user wallets")
    wallets = Accounts.all_user_wallets(params)
  end
end
