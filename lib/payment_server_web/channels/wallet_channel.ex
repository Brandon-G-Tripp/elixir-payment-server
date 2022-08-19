defmodule PaymentServerWeb.WalletChannel do 
  use PaymentServerWeb, :channel

  def join(_channel, _payload, socket) do 
    {:ok, socket}
  end

end
