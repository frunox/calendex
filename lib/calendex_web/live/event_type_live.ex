defmodule CalendexWeb.EventTypeLive do
  use CalendexWeb, :live_view

  def mount(%{"event_type_slug" => _slug} = params, _session, socket) do
    {:ok, socket}
  end
end
