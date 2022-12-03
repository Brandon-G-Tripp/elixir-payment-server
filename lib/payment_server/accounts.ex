defmodule PaymentServer.Accounts do 
  import Ecto.Changeset, only: [change: 2]

  alias EctoShorts.Actions

  alias PaymentServer.Repo
  alias PaymentServer.Accounts.User
  alias PaymentServer.Accounts.Wallet
  alias PaymentServer.ExchangeRatesMonitor.ExchangeRateState
  alias PaymentServerWeb.GraphqlHelpers.Publishing

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
  
  def get_total_worth(%{user_id: user_id, currency: currency}) do 
    with {:ok, user} <- find(%{id: user_id}) do 
      wallets = Repo.all(Ecto.assoc(user, :wallets))
      _balance = reduce_balances(wallets, currency) 
    end
  end

  defp reduce_balances(wallets, currency, sum \\ 0)
  defp reduce_balances([], currency, sum) do 
    {:ok, %{amount: sum, currency: currency, timestamp: DateTime.to_string(DateTime.utc_now)}}
  end
  defp reduce_balances([current_wallet | tail], currency, sum) do 
    value_in_new_currency = get_value_in_new_currency(current_wallet, currency)
    reduce_balances(tail, currency, sum + value_in_new_currency)
  end

  defp get_value_in_new_currency(
    %{currency: wallet_currency, value: value} = _wallet, currency
  ) when wallet_currency === currency do 
    value
  end
  defp get_value_in_new_currency(%{currency: wallet_currency, value: value} = _wallet, currency) do 
    %{rate: exchange_rate} = ExchangeRateState.get_exchange_rate(wallet_currency, currency)

    case value do 
      0 -> 0
      _ -> floor( exchange_rate * value )
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

  defp update_wallet_value(params, amount) do 
    Actions.find_and_update(Wallet, params, value: amount)
  end

  def add_money(%{currency: currency, user_id: user_id, deposit_amount: amount} = params) do 
    {:ok, wallet} = find_wallet_by_currency(%{user_id: user_id, currency: currency})

    Publishing.publish_total_worth_change(wallet)

    update_wallet_value(%{user_id: user_id, currency: currency}, wallet.value + amount)
  end

  def send_money(params) do 
    %{
      sending_user_id: sending_user_id,
      sender_currency: sender_currency,
      receiving_user_id: receiving_user_id,
      receiver_currency: receiver_currency,
      amount: amount
    } = params

    with {:ok, sender_wallet} <- find_wallet_by_currency(%{user_id: sending_user_id, currency: sender_currency}),
      true <- sender_wallet.value >= amount,
      {:ok, receiver_wallet} <- find_wallet_by_currency(%{user_id: receiving_user_id, currency: receiver_currency}) do 
        Repo.transaction(fn -> 
          {:ok, _sender_wallet} = Repo.update(change(sender_wallet, value: sender_wallet.value - amount))
          exchange_amount = get_value_in_new_currency(%{currency: sender_currency, value: amount},  receiver_currency)
          {:ok, receiver_wallet} = Repo.update(change(receiver_wallet, value: receiver_wallet.value + exchange_amount))

          receiver_wallet
        end)

        {:ok, sender_wallet} = find_wallet_by_currency(%{user_id: sending_user_id, currency: sender_currency})
        {:ok, receiver_wallet} = find_wallet_by_currency(%{user_id: receiving_user_id, currency: receiver_currency})

        Publishing.publish_total_worth_change(sender_wallet)       
        Publishing.publish_total_worth_change(receiver_wallet)
         
        {:ok, sender_wallet}
    else
      {:error, error} -> error
      false -> {:error, "Insufficient Funds"}
    end
  end
end
