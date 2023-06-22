defmodule DevFinder.Repo do
  use Ecto.Repo,
    otp_app: :dev_finder,
    adapter: Ecto.Adapters.Postgres
end
