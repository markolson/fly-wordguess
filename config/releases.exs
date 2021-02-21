import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

app_name =
  System.get_env("FLY_APP_NAME") ||
    raise "FLY_APP_NAME not available"

config :word_guess, WordGuessWeb.Endpoint,
  server: true,
  debug_errors: true,
  check_origin: ["https://word-guess.fly.dev"],
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

config :word_guess, WordGuess.Repo,
  # ssl: true,
  adapter: Ecto.Adapters.Postgres,
  url: database_url,
  show_sensitive_data_on_connection_error: true,
  socket_options: [:inet6],
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")


config :logger, :console, format: "[$level] $message\n"
