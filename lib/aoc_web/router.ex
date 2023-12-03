defmodule AocWeb.Router do
  use AocWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AocWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AocWeb do
    pipe_through :browser

    live "/", PageLive, :index

    scope "/:year" do
      live "/", PageLive, :index

      scope "/:day" do
        live "/", DayLive, :index
      end
    end
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AocWeb.Telemetry
    end
  end
end
