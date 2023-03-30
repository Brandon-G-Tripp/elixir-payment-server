# PaymentServer

To Start the local AlphaVantage Exchange Rate Server with Docker:

  * Make sure docker is installed 
  * Run `docker pull mikaak/alpha-vantage:latest` to pull the image into Docker
  * Run `docker run -p 4001:4000 -it mikaak/alpha-vantage:latest` to run the server at port 4001

To start the Phoenix Payment server:

  * Clone the repo
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit `http://localhost:4000/graphiql` from your browser to interact with the payment/exchange server.


