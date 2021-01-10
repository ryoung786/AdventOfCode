defmodule Days.D_11 do
  use Days.Base

  defmodule Robot do
    defstruct dir: :up, panels: %{}, xy: {0, 0}, vm: nil, intcode_state: nil
  end

  @impl true
  def part_one(str) do
    str |> Util.to_intcode_program() |> create_robot() |> run_robot() |> count_painted_panels()
  end

  @impl true
  def part_two(str), do: str |> String.at(0)

  def create_robot(prog) do
    {:ok, vm} = Intcode.new(prog)
    %Robot{vm: vm, intcode_state: Intcode.get_state(vm)}
  end

  def run_robot(%{intcode_state: %{status: :halted}} = robot), do: robot.panels

  def run_robot(%{vm: vm} = robot) do
    input_val = Map.get(robot.panels, robot.xy, 0)
    Intcode.input(vm, input_val)
    intcode_state = Intcode.run_sync(vm)

    [turn_dir, paint_color] =
      if intcode_state.status == :halted,
        do: intcode_state.output,
        else: Intcode.flush_output(vm)

    robot
    |> set_intcode_state(intcode_state)
    |> paint_panel(paint_color)
    |> turn(turn_dir)
    |> move()
    |> run_robot()
  end

  def set_intcode_state(robot, new_state) do
    %{robot | intcode_state: new_state}
  end

  def paint_panel(robot, color), do: put_in(robot.panels[robot.xy], color)

  def turn(%{dir: :up} = robot, 0), do: %{robot | dir: :left}
  def turn(%{dir: :down} = robot, 0), do: %{robot | dir: :right}
  def turn(%{dir: :left} = robot, 0), do: %{robot | dir: :down}
  def turn(%{dir: :right} = robot, 0), do: %{robot | dir: :up}

  def turn(%{dir: :up} = robot, 1), do: %{robot | dir: :right}
  def turn(%{dir: :down} = robot, 1), do: %{robot | dir: :left}
  def turn(%{dir: :left} = robot, 1), do: %{robot | dir: :up}
  def turn(%{dir: :right} = robot, 1), do: %{robot | dir: :down}

  def move(%{xy: {x, y}, dir: :up} = robot), do: %{robot | xy: {x, y + 1}}
  def move(%{xy: {x, y}, dir: :down} = robot), do: %{robot | xy: {x, y - 1}}
  def move(%{xy: {x, y}, dir: :left} = robot), do: %{robot | xy: {x - 1, y}}
  def move(%{xy: {x, y}, dir: :right} = robot), do: %{robot | xy: {x + 1, y}}

  def count_painted_panels(panels), do: panels |> Enum.count()
end
