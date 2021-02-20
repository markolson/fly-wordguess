defmodule WordGuessWeb.GameHelpers do
  @moduledoc false

  @doc ~S"""
    Format elapsed time in seconds to a 1m 12.1s type string

    ## Examples
      iex> WordGuessWeb.GameHelpers.format_time(12.1)
      "12.1s"

      iex> WordGuessWeb.GameHelpers.format_time(59.9)
      "59.9s"

      iex> WordGuessWeb.GameHelpers.format_time(60.1)
      "1m 0.1s"
  """
  def format_time(elapsed) do
    minutes = floor(elapsed / 60)
    seconds = Float.round(elapsed - minutes * 60, 5)
    format_time(minutes, seconds)
  end

  def format_time(0, seconds), do: "#{seconds}s"
  def format_time(minutes, seconds), do: "#{minutes}m #{seconds}s"
end
