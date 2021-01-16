defmodule SiteWeb.Day201911Live do
  use SiteWeb, :live_view
  import Aoc2019.Days.D_11
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    robot = input() |> Aoc2019.Util.to_intcode_program() |> create_robot() |> run_robot()
    {:ok, assign(socket, robot: robot, path: svg_path(robot))}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <svg class="y2019_11" width="600" height="600" viewbox="-75 -50 100 100">

      <mask id="robot-path" xmaskUnits="userSpaceOnUse">
        <path class="clip" d="<%= @path %>" fill="none" stroke="white" />
      </mask>
      <g mask="url(#robot-path)">
        <%= for {{x,y}, 1} <- @robot.panels do %>
          <rect x="<%= x %>" y="<%= y %>" width="1" height="1" fill="white" />
        <% end %>
      </g>
    </svg>
    """
  end

  def svg_path(%{path: hist}) do
    str =
      hist
      |> Enum.reduce([], fn {x, y}, cmds -> ["L#{x} #{y}" | cmds] end)
      |> Enum.join(" ")

    "M0 0 " <> str
  end
end
