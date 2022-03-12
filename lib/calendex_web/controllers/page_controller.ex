defmodule CalendexWeb.PageController do
  use CalendexWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
