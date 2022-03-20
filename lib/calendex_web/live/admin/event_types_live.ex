defmodule CalendexWeb.Admin.EventTypesLive do
  use CalendexWeb, :admin_live_view

  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns, label: "             socket.assigns in admin")
    {:ok, socket, temporary_assigns: [event_types: []]}
  end

  def handle_params(_, _, socket) do
    socket =
      socket
      |> assign(section: "event_types")
      |> assign(page_title: "Event Types")

    {:noreply, socket}
  end
end
