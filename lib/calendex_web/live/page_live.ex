defmodule CalendexWeb.PageLive do
  use CalendexWeb, :live_view

  alias CalendexWeb.Components.EventType

  def mount(_params, _session, socket) do
    event_types = Calendex.available_event_types()

    {:ok, assign(socket, event_types: event_types), temporary_assigns: [event_types: []]}
  end
end
