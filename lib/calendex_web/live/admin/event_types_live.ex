defmodule CalendexWeb.Admin.EventTypesLive do
  use CalendexWeb, :live_view

  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns, label: "             socket.assigns in admin")
    {:ok, socket, temporary_assigns: [event_types: []]}
  end
end
