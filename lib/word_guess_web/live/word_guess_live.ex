defmodule WordGuessWeb.WordGuessLive do
  @moduledoc false
  import WordGuessWeb.GameHelpers
  use WordGuessWeb, :live_view
  @ticker_delay 100

  @impl true
  def handle_params(params, _, socket) do
    socket =
      assign(socket,
        state: :idle,
        guesses: 0,
        elapsed: 0.0,
        error: nil,
        wrong_guesses: %{before: [], after: []},
        guess_history: [],
        replay_uuid: nil
      )
      |> assign_game(params)

    {:noreply, socket}
  end

  defp play(guess, word, socket) do
    # We always count guesses on the score
    guess = String.trim(String.downcase(guess))

    socket =
      socket
      |> assign(
        guess_history:
          socket.assigns.guess_history ++ [%{guess: guess, t: socket.assigns.elapsed}]
      )
      |> assign(guesses: socket.assigns.guesses + 1)

    cond do
      already_guessed(guess, socket.assigns.wrong_guesses) ->
        {:noreply, assign(socket, error: "You already guessed #{guess}!")}

      !Game.is_a_word?(guess) ->
        {:noreply,
         assign(socket, error: Phoenix.HTML.raw("<i>#{guess}</i> is... probably not a real word?"))}

         Game.guess(word, guess) == true ->
        end_and_save(:won, socket)

      true ->
        # If the above isn't `true`, we know it will be the direction we were wrong in
        wrong_direction = Game.guess(word, guess)
        update_guess_list(guess, wrong_direction, socket)
    end
  end

  defp update_guess_list(guess, way, %{assigns: assigns} = socket) do
    new_guess_history = Map.update!(assigns.wrong_guesses, way, &Enum.sort(&1 ++ [guess]))
    {:noreply, assign(socket, error: nil, wrong_guesses: new_guess_history)}
  end

  defp already_guessed(guess, bad_lists) do
    Enum.member?(bad_lists.before, guess) || Enum.member?(bad_lists.after, guess)
  end

  defp assign_game(socket, %{"uuid" => uuid}) do
    game = Game.find_replay(uuid)
    level = game.level
    date = game.day

    word =
      Game.wordlist(level)
      |> Game.daily(Date.from_iso8601!(date))

    assign(socket,
      word: word,
      date: date,
      level: level,
      vs_replay_game: game
    )
  end

  defp assign_game(socket, params) do
    level = Map.get(params, "level", "easy")
    level = if level in ["easy", "hard"], do: level, else: "easy"

    date = Map.get(params, "date", Date.to_string(Date.utc_today()))

    word = Game.wordlist(level) |> Game.daily(Date.from_iso8601!(date))

    assign(socket,
      word: word,
      date: date,
      level: level,
      vs_replay_game: nil
    )
  end

  defp end_and_save(state, socket) do
    {:ok, %{id: uuid}} =
      Game.create_replay(%{
        day: socket.assigns.date,
        level: socket.assigns.level,
        time: socket.assigns.elapsed,
        guesses: socket.assigns.guess_history
      })

    {:noreply, assign(socket, replay_uuid: uuid, state: state)}
  end

  @impl true
  def handle_info(:tick, %{assigns: %{state: :playing}} = socket) do
    Process.send_after(self(), :tick, @ticker_delay)

    {:noreply,
     assign(socket, :elapsed, Float.round(socket.assigns.elapsed + @ticker_delay / 1_000, 5))}
  end

  def handle_info(:tick, socket), do: {:noreply, socket}

  @impl true
  def handle_event("submit", %{"word" => %{"guess" => guess}}, %{assigns: %{word: word}} = socket) do
    play(guess, word, socket)
  end

  @impl true
  def handle_event("give-up", _, socket) do
    end_and_save(:resigned, socket)
  end

  @impl true
  def handle_event("start-elapsed", _, socket) do
    if socket.assigns.elapsed == 0 do
      Process.send_after(self(), :tick, @ticker_delay)
      {:noreply, assign(socket, state: :playing)}
    else
      {:noreply, socket}
    end
  end
end
