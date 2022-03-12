defmodule Calendex.Repo do
  use Ecto.Repo,
    otp_app: :calendex,
    adapter: Ecto.Adapters.Postgres
end
