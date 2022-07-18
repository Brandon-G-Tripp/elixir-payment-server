defmodule PaymentServerWeb.Schema.Queries.User do 
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Resolvers

  object :user_queries do 
    field :user, :user do 
      arg :id, non_null(:id)

      resolve &Resolvers.User.find/2
    end

    field :users, list_of(:user) do 
      resolve &Resolvers.User.all/2
    end
  end
end
