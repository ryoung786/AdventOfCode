defmodule AocWeb.PageLive do
  use AocWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    year = Map.get(params, "year", "2021")
    {:ok, assign(socket, year: year)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    year = Map.get(params, "year", "2021")
    {:noreply, assign(socket, year: year)}
  end
end
