defmodule PaymentServerWeb.Schema.Mutations.User do 
  use Absinthe.Schema.Notation

  alias PaymentServerWeb.Resolvers

  object :user_mutations do
    field :create_user, :user do 
      arg :name, non_null(:string)
      arg :email, non_null(:string)

      resolve &Resolvers.User.create_user/2
    end

    # send money mutations
  end
end
