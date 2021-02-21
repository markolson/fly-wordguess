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

    live "/", WordGuessLive
    live "/vs/:uuid", WordGuessLive

    import Phoenix.LiveDashboard.Router
    live_dashboard "/dashboard", metrics: WordGuessWeb.Telemetry
  end
end
