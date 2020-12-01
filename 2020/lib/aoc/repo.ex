defmodule Aoc.Repo do
  use Ecto.Repo,
    otp_app: :aoc,
    adapter: Ecto.Adapters.Postgres
end
