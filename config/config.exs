# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :word_guess,
  ecto_repos: [WordGuess.Repo]

# Configures the endpoint
config :word_guess, WordGuessWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mb4yrrWruTc6zqjcoWUa5bhtPpHHHH0dQIjLJDeXC2Bzt68m/TSTqyVybiifBUMX",
  render_errors: [view: WordGuessWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: WordGuess.PubSub,
  live_view: [signing_salt: "67YTBCU9"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
