defmodule WordGuessWeb.Router do
  use WordGuessWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WordGuessWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", WordGuessWeb do
    pipe_through :browser

    live "/word-guess", WordGuessLive
    live "/word-guess/vs/:uuid", WordGuessLive
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: WordGuessWeb.Telemetry
    end
  end
end
