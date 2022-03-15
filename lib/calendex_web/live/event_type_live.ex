defmodule CalendexWeb.EventTypeLive do
  use CalendexWeb, :live_view

  alias CalendexWeb.Components.EventType

  def mount(%{"event_type_slug" => slug}, _session, socket) do
    case Calendex.get_event_type_by_slug(slug) do
      {:ok, event_type} ->
        socket =
          socket
          |> assign(event_type: event_type)
          |> assign(page_title: event_type.name)
          |> IO.inspect(label: "^^^^ socket in event_type_live.ex")
          |> assign_dates()

        {:ok, socket}

      {:error, :not_found} ->
        {:ok, socket, layout: {CalendexWeb.LayoutView, "not_found.html"}}
    end
  end

  defp assign_dates(socket) do
    # IO.inspect(socket.assigns, label: "$$$$$$$$$$$ socket.assigns")
    current = Timex.today(socket.assigns.time_zone)
    beginning_of_month = Timex.beginning_of_month(current)
    end_of_month = Timex.end_of_month(current)

    previous_month =
      beginning_of_month
      |> Timex.add(Timex.Duration.from_days(-1))
      |> date_to_month()

    next_month =
      end_of_month
      |> Timex.add(Timex.Duration.from_days(1))
      |> date_to_month()

    socket
    |> assign(current: current)
    |> assign(beginning_of_month: beginning_of_month)
    |> assign(end_of_month: end_of_month)
    |> assign(previous_month: previous_month)
    |> assign(next_month: next_month)
  end

  defp date_to_month(date_time) do
    Timex.format!(date_time, "{YYYY}-{0M}")
  end
end
