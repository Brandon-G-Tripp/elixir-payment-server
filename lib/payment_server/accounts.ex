defmodule PaymentServer.Accounts do 
  alias EctoShorts.Actions
  alias Ecto.Query

  alias PaymentServer.Repo
  alias PaymentServer.Accounts.User
  alias PaymentServer.Accounts.Wallet
  alias PaymentServer.ExchangeRatesMonitor

  def all do 
    Actions.all(User)
  end

  def find(params) do 
    IO.inspect(params, label: "params in find func")
    res = Actions.find(User, params)

    case res do 
      {:error, _} -> {:error, "User not found"}
      _ -> res
    end
  end


  def get_total_worth(%{user_id: user_id, currency: currency}) do 
    with {:ok, user} <- find(%{id: user_id}) do 
      wallets = Repo.all(Ecto.assoc(user, :wallets))
      balance = reduce_balances(wallets, currency)
    end
  end

  defp reduce_balances(wallets, currency, sum \\ 0)
  defp reduce_balances([], currency, sum) do 
    {:ok, %{amount: sum, currency: currency, timestamp: DateTime.utc_now |> DateTime.to_string}}
  end
  defp reduce_balances([current_wallet | tail], currency, sum) do 
    value_in_new_currency = 
      current_wallet 
      |> get_value_in_new_currency(currency)
    reduce_balances(tail, currency, sum + value_in_new_currency)
  end

  defp get_value_in_new_currency(
    %{currency: wallet_currency, value: value} = _wallet, currency
  ) when wallet_currency === currency do 
    value
  end
  defp get_value_in_new_currency(%{currency: wallet_currency, value: value} = _wallet, currency) do 
    %{rate: exchange_rate} = ExchangeRatesMonitor.get_exchange_rate(wallet_currency, currency)
    exchange_rate_float = String.to_float(exchange_rate)
    case value do 
      0 -> 0
      _ -> exchange_rate_float * value
    end
  end

  def create_user(params) do 
    Actions.create(User, params)
  end

  def all_wallets(params) do 
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

  defp update_wallet_value( params, amount) do 
    IO.inspect(amount)
    Actions.find_and_update(Wallet, params, value: amount)
    |> IO.inspect(label: "return of update")
  end

  def add_money(%{currency: currency, user_id: user_id, deposit_amount: amount} = params) do 
    {:ok, wallet} = find_wallet_by_currency(%{user_id: user_id, currency: currency})

    update_wallet_value(%{user_id: user_id, currency: currency}, wallet.value + amount)
  end
end
