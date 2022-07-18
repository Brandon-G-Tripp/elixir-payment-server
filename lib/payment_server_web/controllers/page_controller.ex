defmodule PaymentServerWeb.PageController do
  use PaymentServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
