defmodule Calendex.Event.Repo do
  import Ecto.Query
  alias Calendex.{Event, Repo}

  def insert(params) do
    %Event{}
    |> Event.changeset(params)
    |> Repo.insert()
  end

  def get(id) do
    Event
    |> Repo.get(id)
    |> Repo.preload(:event_type)
    |> case do
      nil ->
        {:error, :not_found}

      event ->
        {:ok, event}
    end
  end

  def get_by_start_date(date) do
    IO.inspect(date, label: "1111 date  1111")

    Event
    |> IO.inspect(label: "*&^*&^ Event *&^*&^")
    |> where([e], fragment("?::date", e.start_at) == ^date)
    |> order_by(:start_at)
    |> Repo.all()
  end
end
