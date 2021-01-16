defmodule SiteWeb.Day201911Live do
  use SiteWeb, :live_view
  import Aoc2019.Days.D_11
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    if socket.connected? do
      program = input() |> Aoc2019.Util.to_intcode_program()
      robot = program |> create_robot() |> run_robot()
      robot2 = program |> create_robot()
      robot2 = %{robot2 | panels: %{{0, 0} => 1}} |> run_robot()

      {:ok,
       assign(socket, robot: robot, path: svg_path(robot), robot2: robot2, path2: svg_path(robot2))}
    else
      blank_robot = %Aoc2019.Days.D_11.Robot{}
      {:ok, assign(socket, robot: blank_robot, path: "", robot2: blank_robot, path2: "")}
    end
  end

  @impl true
  def render(assigns) do
    ~L"""
    <svg class="y2019_11" width="600" height="600" viewbox="-75 -50 100 100">

      <mask id="robot-path" xmaskUnits="userSpaceOnUse">
        <path class="clip" d="<%= @path %>" fill="none" stroke="white" />
      </mask>
      <g class="panels" mask="url(#robot-path)">
        <%= for {{x,y}, 1} <- @robot.panels do %>
          <rect x="<%= x %>" y="<%= y %>" width="1" height="1" fill="white" />
        <% end %>
      </g>

      <circle r="3" fill="blue">
        <animateMotion dur="10s"
                       fill="freeze"
                       path="<%= @path %>" />
      </circle>
    </svg>


    <svg class="y2019_11" width="600" height="100" viewbox="0 -1 40 9">

      <mask id="robot-path2" xmaskUnits="userSpaceOnUse">
        <path class="clip2" d="<%= @path2 %>" fill="none" stroke="white" />
      </mask>
      <g class="panels" mask="url(#robot-path2)">
        <%= for {{x,y}, 1} <- @robot2.panels do %>
          <rect x="<%= x %>" y="<%= y %>" width="1" height="1" fill="white" />
        <% end %>
      </g>

      <circle r="1" fill="blue">
        <animateMotion dur="10s"
                       fill="freeze"
                       path="<%= @path2 %>" />
      </circle>
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
