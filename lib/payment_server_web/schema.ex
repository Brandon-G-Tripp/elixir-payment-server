defmodule PaymentServerWeb.Schema do 
  use Absinthe.Schema

  # import types (graphql objects)
  import_types PaymentServerWeb.Types.User

  import_types PaymentServerWeb.Schema.Mutations.User
  import_types PaymentServerWeb.Schema.Mutations.UserWallet

  import_types PaymentServerWeb.Schema.Queries.User
  import_types PaymentServerWeb.Schema.Queries.UserWallet

  query do 
    import_fields :user_queries
    import_fields :user_wallet_queries
  end
  mutation do 
    import_fields :user_mutations
    import_fields :user_wallet_mutations
  end
  # subscriptions
  #
  def context(ctx) do 
    source = Dataloader.Ecto.new(PaymentServer.Repo)
    dataloader = Dataloader.add_source(Dataloader.new(), PaymentServer.Accounts, source)

    Map.put(ctx, :loader, dataloader)
  end

  def plugins do 
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
