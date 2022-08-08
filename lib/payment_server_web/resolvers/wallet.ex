defmodule PaymentServerWeb.Resolvers.Wallet do 
  alias PaymentServer.Accounts

  
  def create_wallet(params, _) do 
    Accounts.create_wallet(params)
  end

  def find_wallet_by_currency(%{user_id: id, currency: currency}, _) do 
    id = String.to_integer(id)
    Accounts.find_wallet_by_currency(%{user_id: id, currency: currency})
  end

  def all_wallets(params, _) do 
    Accounts.all_wallets(params)
  end

  def add_money(params, _) do 
    Accounts.add_money(params)
  end

  def send_money(params, _) do 
    Accounts.send_money(params)
  end
end
