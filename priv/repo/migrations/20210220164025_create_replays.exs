defmodule WordGuess.Repo.Migrations.CreateReplays do
  use Ecto.Migration

  def change do
    create table(:replays) do
      add :time, :decimal
      add :played_at, :naive_datetime
      add :day, :string
      add :level, :string
      add :guesses, {:array, :map}

      timestamps()
    end

  end
end
