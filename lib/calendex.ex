defmodule Calendex do
  @moduledoc """
  Calendex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  defdelegate available_event_types, to: Calendex.EventType.Repo, as: :available
end
