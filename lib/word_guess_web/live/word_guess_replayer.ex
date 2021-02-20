defmodule WordGuessWeb.WordGuessReplayer do
  @moduledoc false
  use Phoenix.LiveComponent
  import WordGuessWeb.GameHelpers

  @impl true
  def update(%{elapsed: 0.0} = assigns, socket) do
    word =
      Game.wordlist(assigns.game.level)
      |> Game.daily(Date.from_iso8601!(assigns.game.day))

    {:ok,
     assign(socket,
       complete: assigns.complete,
       guesses: assigns.game.guesses,
       game: assigns.game,
       word: word,
       replay_state: nil,
       wrong_guesses: %{before: [], after: []},
       elapsed: assigns.elapsed
     )}
  end

  # Finish Game when it's completes
  def update(%{complete: true} = params, %{assigns: %{complete: false}} = socket) do
    socket =
      Enum.reduce(socket.assigns.guesses, socket, fn _guess, s ->
        play_word(s)
      end)
      |> assign(complete: true)

    # with our socket updated, recurse?
    update(params, socket)
  end

  def update(%{elapsed: ts}, %{assigns: %{replay_state: nil, guesses: []}} = socket) do
    {:ok, assign(socket, elapsed: ts, replay_state: :lost)}
  end

  def update(%{elapsed: ts}, %{assigns: %{guesses: []}} = socket) do
    {:ok, assign(socket, elapsed: ts)}
  end

  def update(%{elapsed: ts}, socket) do
    [next_guess | _] = socket.assigns.guesses

    socket = if ts >= next_guess["t"], do: play_word(socket), else: socket
    {:ok, assign(socket, elapsed: ts)}
  end

  def update(_, socket), do: {:ok, socket}

  defp play_word(socket) do
    [next_guess | rest_of_guesses] = socket.assigns.guesses

    play(next_guess["guess"], socket.assigns.word, socket)
    |> assign(guesses: rest_of_guesses)
  end

  defp play(guess, word, socket) do
    cond do
      !Game.is_a_word?(guess) ->
        socket

      Game.guess(word, guess) == true ->
        assign(socket, replay_state: :won)

      true ->
        # If the above isn't `true`, we know it will be the direction we were wrong in
        wrong_direction = Game.guess(word, guess)
        update_guess_list(guess, wrong_direction, socket)
    end
  end

  defp update_guess_list(guess, way, %{assigns: assigns} = socket) do
    new_guess_history = Map.update!(assigns.wrong_guesses, way, &Enum.sort(&1 ++ [guess]))
    assign(socket, wrong_guesses: new_guess_history)
  end
end
