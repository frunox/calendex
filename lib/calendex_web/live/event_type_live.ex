defmodule CalendexWeb.EventTypeLive do
  use CalendexWeb, :live_view
  alias CalendexWeb.Components.EventType
  alias Timex.Duration

  def mount(%{"event_type_slug" => slug}, _session, socket) do
    case Calendex.get_event_type_by_slug(slug) do
      {:ok, event_type} ->
        socket =
          socket
          |> assign(event_type: event_type)
          |> assign(page_title: event_type.name)

        {:ok, socket, temporary_assigns: [time_slots: []]}

      {:error, :not_found} ->
        {:ok, socket, layout: {CalendexWeb.LayoutView, "not_found.html"}}
    end
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign_dates(params)
      |> assign_time_slots(params)

    {:noreply, socket}
  end

  defp assign_dates(socket, params) do
    # IO.inspect(socket.assigns, label: "()()() socket.assigns in assign_dates()")
    current = current_from_params(socket, params)
    beginning_of_month = Timex.beginning_of_month(current)
    end_of_month = Timex.end_of_month(current)

    previous_month =
      beginning_of_month
      |> Timex.add(Duration.from_days(-1))
      |> date_to_month()

    # IO.inspect(previous_month, label: "assign_dates previous_month")

    next_month =
      end_of_month
      |> Timex.add(Duration.from_days(1))
      |> date_to_month()

    socket
    |> assign(current: current)
    |> assign(beginning_of_month: beginning_of_month)
    |> assign(end_of_month: end_of_month)
    |> assign(previous_month: previous_month)
    |> assign(next_month: next_month)
  end

  defp current_from_params(socket, %{"date" => date}) do
    # IO.inspect(date, label: "!!!!!! in current_from_params date")

    case Timex.parse(date, "{YYYY}-{0M}-{D}") do
      {:ok, current} ->
        NaiveDateTime.to_date(current)

      _ ->
        Timex.today(socket.assigns.time_zone)
    end
  end

  defp current_from_params(socket, %{"month" => month}) do
    case Timex.parse("#{month}-01", "{YYYY}-{0M}-{D}") do
      {:ok, current} ->
        NaiveDateTime.to_date(current)

      _ ->
        Timex.today(socket.assigns.time_zone)
    end
  end

  defp current_from_params(socket, _) do
    Timex.today(socket.assigns.time_zone)
  end

  defp date_to_month(date_time) do
    Timex.format!(date_time, "{YYYY}-{0M}")
  end

  defp assign_time_slots(socket, %{"date" => _}) do
    date = socket.assigns.current
    time_zone = socket.assigns.time_zone
    event_duration = socket.assigns.event_type.duration
    time_slots = Calendex.build_time_slots(date, time_zone, event_duration)

    socket
    |> assign(time_slots: time_slots)
    |> assign(selected_date: date)

    # |> IO.inspect(label: "#@#@#@ selected_date in assign_time_slots")
  end

  defp assign_time_slots(socket, _), do: socket
end
