defmodule CalendexWeb.Live.InitAssigns do
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    owner = Application.get_env(:calendex, :owner)
    #
    # "America/Chicago"
    # time_zone = get_connect_params(socket)["timezone"]
    time_zone = get_connect_params(socket)["timezone"] || owner.time_zone
    # IO.inspect(owner, label: "^^^^^^^^ owner")
    IO.inspect(time_zone, label: "^^^ time_zone in init_assigns.ex")

    socket =
      socket
      |> assign(:time_zone, time_zone)
      |> assign(:owner, owner.name)

    IO.inspect(socket.assigns, label: "^^^^^^^ socket.assigns in init_assigns.ex")

    {:cont, socket}
  end

  def on_mount(:private, _params, _session, socket) do
    owner = Application.get_env(:calendex, :owner)

    {:cont, assign(socket, :owner, owner)}
  end
end
