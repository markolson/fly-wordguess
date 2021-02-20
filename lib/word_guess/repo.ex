defmodule WordGuess.Repo do
  use Ecto.Repo,
    otp_app: :word_guess,
    adapter: Ecto.Adapters.Postgres
end
