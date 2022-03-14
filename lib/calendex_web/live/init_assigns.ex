defmodule CalendexWeb.Live.InitAssigns do
  import Phoenix.LiveView

  # this is a hook

  def on_mount(:default, _params, _session, socket) do
    owner = Application.get_env(:calendex, :owner)
    socket = assign(socket, :owner, owner)

    {:cont, socket}
  end
end
