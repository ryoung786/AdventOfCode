defmodule SiteWeb.Router do
  use SiteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SiteWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :valid_day do
    plug(:ensure_valid_day)
  end

  scope "/", SiteWeb do
    pipe_through :browser

    live "/", PageLive, :index

    scope "/days/:day" do
      pipe_through :valid_day
      live "/", DayLive, :index
    end
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: SiteWeb.Telemetry
    end
  end

  defp ensure_valid_day(conn, _opts) do
    day = conn.path_params["day"] |> String.to_integer()

    if day in 1..25 do
      conn
    else
      conn
      |> put_status(404)
      |> put_view(Aoc2020Web.ErrorView)
      |> render(:"404")
      |> halt()
    end
  end
end
