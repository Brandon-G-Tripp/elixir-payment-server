defmodule PaymentServer.Accounts do 
  alias PaymentServer.Repo
  alias PaymentServer.Accounts.User
  alias PaymentServer.Accounts.Wallet
  alias EctoShorts.Actions

  def all do 
    Actions.all(User)
  end

  def find(params) do 
    res = Actions.find(User, params)

    case res do 
      {:error, _} -> {:error, "User not found"}
      _ -> res
    end
  end

  def create_user(params) do 
    Actions.create(User, params)
  end

  def all_wallets(params) do 
    IO.inspect(params, label: "params in all user wallets accoutn")
    {:ok, Actions.all(Wallet, params)}    
  end

  def create_wallet(params) do 
    Actions.find_or_create(Wallet, params)
  end

  def find_wallet_by_currency(params) do 
    res = Actions.find(Wallet, params)

    case res do 
      {:error, _} -> {:error, "Wallet does not exist in this currency"}
      _ -> res
    end
  end
end
