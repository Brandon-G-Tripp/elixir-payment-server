defmodule PaymentServerWeb.Types.Balance do 
  use Absinthe.Schema.Notation 

  object :balance do 
    field :amount, :integer
    field :currency, :currency
    field :timestamp, :string
  end
end
