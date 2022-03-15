defmodule CalendexWeb.EventTypeLive do
  use CalendexWeb, :live_view
  alias CalendexWeb.Components.EventType
  alias Timex.Duration

  def mount(%{"event_type_slug" => slug}, _session, socket) do
    IO.inspect(socket.assigns, label: "in event_type_live mount socket.assigns")

    case Calendex.get_event_type_by_slug(slug) do
      {:ok, event_type} ->
        socket =
          socket
          |> assign(event_type: event_type)
          |> assign(page_title: event_type.name)

        # |> assign(time_zone: "America/Chicago")

        # |> assign_dates()

        {:ok, socket}

      {:error, :not_found} ->
        {:ok, socket, layout: {CalendexWeb.LayoutView, "not_found.html"}}
    end
  end

  def handle_params(params, _uri, socket) do
    # we call `assign_dates` passing `params` as well
    socket = assign_dates(socket, params)
    {:noreply, socket}
  end

  defp assign_dates(socket, params) do
    IO.inspect(socket.assigns, label: "()()() socket.assigns in assign_dates()")
    current = current_from_params(socket, params)
    beginning_of_month = Timex.beginning_of_month(current)
    end_of_month = Timex.end_of_month(current)

    previous_month =
      beginning_of_month
      |> Timex.add(Duration.from_days(-1))
      |> date_to_month()

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
    IO.inspect(date, label: "!!!!!! in current_from_params date")

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
end
