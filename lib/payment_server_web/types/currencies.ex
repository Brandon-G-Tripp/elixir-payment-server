defmodule PaymentServerWeb.Types.Currencies do 
  use Absinthe.Schema.Notation

  @desc "An available currency"
  enum :currency, values: ["USD", "CAD"]
end
