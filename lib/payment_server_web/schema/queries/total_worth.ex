defmodule PaymentServerWeb.Schema.Queries.TotalWorth do 
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Resolvers

  object :total_worth_queries do 
    field :total_worth, :balance do 
      arg :user_id, non_null(:id)
      arg :currency, non_null(:currency)
      resolve &Resolvers.TotalWorth.get_total_worth/2
    end
  end
end
