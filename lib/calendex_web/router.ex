defmodule CalendexWeb.Router do
  use CalendexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CalendexWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CalendexWeb do
    pipe_through :browser

    live "/", PageLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", CalendexWeb do
  #   pipe_through :api
  # end
end
