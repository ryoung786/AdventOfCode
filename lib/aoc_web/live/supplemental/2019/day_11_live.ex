defmodule AocWeb.Supplemental.Year2019.Day11Live do
  use AocWeb, :live_view
  import Aoc.Year2019.Day11
  alias Aoc.Utils.Input
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      lv_pid = self()
      Task.start_link(fn -> send(lv_pid, {:solved, solve()}) end)
    end

    blank_robot = %Aoc.Year2019.Day11.Robot{}
    {:ok, assign(socket, robot: blank_robot, path: "", robot2: blank_robot, path2: "")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <svg class="y2019_11" width="600" height="600" viewbox="-75 -50 100 100">
      <mask id="robot-path" xmaskUnits="userSpaceOnUse">
        <path class="clip" d={@path} fill="none" stroke="white" />
      </mask>
      <g class="panels" mask="url(#robot-path)">
        <rect :for={{{x, y}, 1} <- @robot.panels} x={x} y={y} width="1" height="1" fill="white" />
      </g>

      <%= if @path != "" do %>
        <circle r="3" fill="blue">
          <animateMotion dur="10s" fill="freeze" path={@path} />
        </circle>
      <% end %>
    </svg>

    <svg class="y2019_11" width="600" height="100" viewbox="0 -1 40 9">
      <mask id="robot-path2" xmaskUnits="userSpaceOnUse">
        <path class="clip2" d={@path2} fill="none" stroke="white" />
      </mask>
      <g class="panels" mask="url(#robot-path2)">
        <rect :for={{{x, y}, 1} <- @robot2.panels} x={x} y={y} width="1" height="1" fill="white" />
      </g>

      <circle :if={@path2 != ""} r="1" fill="blue">
        <animateMotion dur="10s" fill="freeze" path={@path2} />
      </circle>
    </svg>
    """
  end

  @impl true
  def handle_info({:solved, {robot1, robot2}}, socket) do
    {:noreply,
     assign(socket,
       robot: robot1,
       path: svg_path(robot1),
       robot2: robot2,
       path2: svg_path(robot2)
     )}
  end

  def svg_path(%{path: hist}) do
    str =
      hist
      |> Enum.reduce([], fn {x, y}, cmds -> ["L#{x} #{y}" | cmds] end)
      |> Enum.join(" ")

    "M0 0 " <> str
  end

  defp solve() do
    program = input() |> Input.to_intcode_program()
    robot1 = program |> create_robot() |> run_robot()
    robot2 = program |> create_robot()
    robot2 = %{robot2 | panels: %{{0, 0} => 1}} |> run_robot()
    {robot1, robot2}
  end
end
