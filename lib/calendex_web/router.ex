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

  # scope "/", CalendexWeb do
  #   pipe_through :browser

  #   live "/", PageLive
  # end

  # public route for live session
  live_session :public, on_mount: CalendexWeb.Live.InitAssigns do
    scope "/", CalendexWeb do
      pipe_through :browser

      live "/", PageLive
      live "/:event_type_slug", EventTypeLive
      live "/:event_type_slug/:time_slot", ScheduleEventLive
      live "/events/:event_type_slug/:event_id", EventsLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", CalendexWeb do
  #   pipe_through :api
  # end
end
