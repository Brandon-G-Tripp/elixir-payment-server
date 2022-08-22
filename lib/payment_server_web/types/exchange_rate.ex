defmodule PaymentServerWeb.Types.ExchangeRate do 
  use Absinthe.Schema.Notation

  @desc "a sending currency and receiving currency"
  object :exchange_rate do 
    field :to_currency, :currency
    field :from_currency, :currency
    field :rate, :float
  end
end
