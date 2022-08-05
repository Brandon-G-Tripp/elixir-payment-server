defmodule PaymentServerWeb.Resolvers.TotalWorth do 
  alias PaymentServer.Accounts
  
  def get_total_worth(params, _) do 
    Accounts.get_total_worth(params)
  end
end
