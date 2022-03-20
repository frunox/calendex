defmodule Calendex.TimeSlots do
  alias Calendex.Event.Repo, as: EventRepo

  @spec build(Date.t(), String.t(), non_neg_integer) :: [DateTime.t()]
  def build(date, time_zone, duration) do
    from =
      date
      |> Timex.to_datetime(time_zone)
      |> Timex.set(hour: day_start())

    to = Timex.set(from, hour: day_end())
    # Get the booked events for the given date
    IO.inspect(date, label: "     date in time_slots.ex")
    date_events = EventRepo.get_by_start_date(date)

    from
    |> Stream.iterate(&DateTime.add(&1, duration * 60, :second))
    |> Stream.take_while(&(DateTime.diff(to, &1) > 0))
    # Reject time slots overlapping booked events
    |> Stream.reject(&reject_overlaps(&1, date_events, duration))
    |> Enum.to_list()
  end

  defp day_start, do: Application.get_env(:calendex, :owner)[:day_start]
  defp day_end, do: Application.get_env(:calendex, :owner)[:day_end]

  defp reject_overlaps(time_slot, date_events, duration) do
    next_time_slot = DateTime.add(time_slot, duration * 60, :second)

    Enum.any?(date_events, fn event ->
      if DateTime.compare(event.start_at, time_slot) == :lt do
        DateTime.compare(event.end_at, time_slot) == :gt
      else
        DateTime.compare(event.start_at, next_time_slot) == :lt
      end
    end)
  end
end
