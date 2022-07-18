defmodule PaymentServerWeb.Router do
  use PaymentServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphql",
      Absinthe.Plug,
      schema: PaymentServerWeb.Schema

    forward "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: PaymentServerWeb.Schema,
      # add socket here
      interface: :playground
  end
end
