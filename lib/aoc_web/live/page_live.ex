defmodule AocWeb.PageLive do
  use AocWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    years = File.ls!(Path.join(["lib", "aoc", "years"])) |> Enum.sort()
    year = Map.get(params, "year", "2021")
    {:ok, assign(socket, years: years, selected_year: year)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    year = Map.get(params, "year", "2021")
    {:noreply, assign(socket, selected_year: year)}
  end
end
