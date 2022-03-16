defmodule CalendexWeb.ScheduleEventLive do
  use CalendexWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
