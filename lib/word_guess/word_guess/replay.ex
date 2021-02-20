defmodule WordGuess.Game.Replay do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "replays" do
    field :day, :string
    field :guesses, {:array, :map}
    field :level, :string
    field :played_at, :naive_datetime
    field :time, :decimal

    timestamps()
  end

  @doc false
  def changeset(replay, attrs) do
    replay
    |> cast(attrs, [:time, :played_at, :day, :level, :guesses])
    |> validate_required([:time, :played_at, :day, :level, :guesses])
  end
end
