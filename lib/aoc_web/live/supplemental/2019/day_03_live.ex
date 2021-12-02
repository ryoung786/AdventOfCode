defmodule AocWeb.Supplemental.Year2019.Day03Live do
  use AocWeb, :live_view
  import Aoc.Year2019.Day03
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    [wire_a, wire_b] = input() |> String.split("\n", trim: true)
    {:ok, assign(socket, wire_a: wire_a, wire_b: wire_b)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <svg class="y2019_03" width="588" height="1000" viewbox="-1500 -7100 10000 17000">
      <%= render_wire(@wire_a, "red", "wire_a") %>
      <%= render_wire(@wire_b, "blue", "wire_b") %>
    </svg>
    """
  end

  def to_svg(wire_str) do
    wire_str
    |> String.split(",", trim: true)
    |> Enum.reduce(["M 0 0"], fn
      "R" <> val, path -> path ++ ["h #{val}"]
      "L" <> val, path -> path ++ ["h #{-1 * String.to_integer(val)}"]
      "D" <> val, path -> path ++ ["v #{val}"]
      "U" <> val, path -> path ++ ["v #{-1 * String.to_integer(val)}"]
    end)
    |> Enum.join(" ")
  end

  def render_wire(wire, color, class) do
    ~e{<path class="<%= class %>" d="<%= to_svg(wire) %>" fill="transparent" stroke="<%= color %>" />}
  end
end
