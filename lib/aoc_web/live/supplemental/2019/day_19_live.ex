defmodule AocWeb.Supplemental.Year2019.Day19Live do
  use AocWeb, :live_view
  alias Aoc.Year2019.Day19, as: D19
  alias Aoc.Utils.Input
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, sleigh_x: nil, sleigh_y: nil, map: %{})
    socket = if connected?(socket), do: explore(socket), else: socket
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="y2019_15">
      <div class="answers"></div>
      <svg width="600" height="600" viewbox="0 0 1200 1200">
        <%= for {y, {xmin, xmax}} <- @map do %>
          <path
            class="beam"
            d={"M#{xmin} #{y} h#{1 + xmax - xmin} v1 h-#{1 + xmax - xmin} z"}
            stroke="none"
            fill="tomato"
          />
        <% end %>

        <%= if @sleigh_x != nil do %>
          <rect x={@sleigh_x} y={@sleigh_y} width="100" height="100" fill="none" stroke="black" />
        <% end %>
      </svg>
    </div>
    """
  end

  def explore(socket) do
    prog = D19.input() |> Input.to_intcode_program()
    map = D19.gen_map(prog)
    {x, y} = D19.get_sleigh_xy(prog, map)
    assign(socket, map: map, sleigh_x: x, sleigh_y: y)
  end
end
