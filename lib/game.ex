defmodule Game do
  @moduledoc false

  @doc ~S"""
    Reads a gzip'd file of words from priv/words

    ## Examples
      iex> Game.wordlist("easy") |> Enum.member?("easy")
      true

      iex> Game.wordlist("easy-peasy") |> Enum.member?("easy")
      ** (File.Error) could not stream "priv/words/easy-peasy.gz": no such file or directory
  """
  def wordlist(filename) do
    path = Path.join("priv/words/", filename <> ".gz")

    Application.app_dir(:word_guess, path)
    |> File.stream!()
    |> StreamGzip.gunzip()
    |> Enum.into("")
    |> String.split("\n")
  end

  @all_words File.read!("priv/words/english") |> String.split("\n", trim: true)

  def is_a_word?(guess) do
    Enum.member?(@all_words, String.downcase(guess))
  end

  @doc ~S"""
    Pick a single word out of a wordlist

    ## Examples
      iex> Game.wordlist("easy") |> Game.daily() |> is_binary
      true

      iex> Game.wordlist("easy") |> Game.daily(~D[2021-02-11])
      "picture"
  """
  def daily(wordlist), do: daily(wordlist, Date.utc_today())

  def daily(wordlist, date) do
    {d, _} = Date.day_of_era(date)
    Enum.at(wordlist, rem(d, Enum.count(wordlist)))
  end

  @doc ~S"""
    Pick a single word out of a wordlist

    ## Examples
      iex> Game.guess("right", "right")
      true

      iex> Game.guess("right", "Incorrect")
      :before

      iex> Game.guess("right", "incorrect")
      :before

      iex> Game.guess("right", "wrong")
      :after

      iex> Game.guess("right", "Wrong")
      :after
  """
  def guess(word, word), do: true

  def guess(word, guess) do
    if word > String.downcase(guess), do: :before, else: :after
  end

  import Ecto.Query, warn: false
  alias WordGuess.Repo
  alias WordGuess.Game.Replay

  def find_replay(id), do: Repo.get!(Replay, id)

  # Game.create_replay(%{day: "2021-02-15", level: "easy", time: 12.1, guesses: []})
  def create_replay(opts) do
    %Replay{}
    |> Replay.changeset(Map.merge(opts, %{played_at: NaiveDateTime.utc_now()}))
    |> Repo.insert()
  end
end
