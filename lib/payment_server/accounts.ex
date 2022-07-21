defmodule PaymentServer.Accounts do 
  alias PaymentServer.Repo
  alias PaymentServer.Accounts.User
  alias PaymentServer.Accounts.Wallet
  alias EctoShorts.Actions

  def all do 
    Actions.all(User)
  end

  def find(params) do 
    Actions.find(User, params)
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
    # params
    # |> Wallet.create_changeset
    # |> Repo.insert
  end

  def find_wallet_by_currency(params) do 
    {:ok, wallet} = Actions.find(Wallet, params)
  end
end
