defmodule WordGuess.Repo do
  @env Mix.env()
  def env, do: @env

  use Ecto.Repo,
    otp_app: :word_guess,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    {:ok, Keyword.put(config, :url, System.get_env("DATABASE_URL"))}
  end
end
