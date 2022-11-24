defmodule LiveMovie.Repo do
  use Ecto.Repo,
    otp_app: :live_movie,
    adapter: Ecto.Adapters.Postgres
end
