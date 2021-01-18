defmodule Aoc2019.Days.D_15 do
  use Aoc2019.Days.Base
  import Enum

  @impl true
  def part_one(_str) do
    # str |> Util.to_intcode_program() |> start_robot() |> find_oxygen() |> elem(0)
    1
  end

  @impl true
  def part_two(_str) do
    3
  end

  def start_robot(prog) do
    {:ok, vm} = Intcode.new(prog)
    vm
  end

  def find_oxygen(vm, xy \\ {0, 0}, dir \\ [1, 4, 2, 3], map \\ %{}, move_resp \\ -1)
  def find_oxygen(_vm, xy, _dir, map, 2), do: {xy, map}

  def find_oxygen(vm, xy, [input | _] = dir, map, _move_resp) do
    IO.inspect({xy, input}, label: "[robot, dir] ")
    Intcode.input(vm, input)

    %{output: [move_resp | _]} = Intcode.run_sync(vm)
    {xy, map} = update(map, xy, input, move_resp)

    dir = turn_robot(dir, move_resp)

    find_oxygen(vm, xy, dir, map, move_resp)
  end

  def update(map, {x, y}, 1, 0), do: {{x, y}, Map.put(map, {x, y - 1}, :wall)}
  def update(map, {x, y}, 2, 0), do: {{x, y}, Map.put(map, {x, y + 1}, :wall)}
  def update(map, {x, y}, 3, 0), do: {{x, y}, Map.put(map, {x - 1, y}, :wall)}
  def update(map, {x, y}, 4, 0), do: {{x, y}, Map.put(map, {x + 1, y}, :wall)}

  def update(map, {x, y}, 1, n), do: {{x, y - 1}, Map.put(map, {x, y - 1}, empty_or_o2(n))}
  def update(map, {x, y}, 2, n), do: {{x, y + 1}, Map.put(map, {x, y + 1}, empty_or_o2(n))}
  def update(map, {x, y}, 3, n), do: {{x - 1, y}, Map.put(map, {x - 1, y}, empty_or_o2(n))}
  def update(map, {x, y}, 4, n), do: {{x + 1, y}, Map.put(map, {x + 1, y}, empty_or_o2(n))}

  def empty_or_o2(1), do: :empty
  def empty_or_o2(2), do: :o2

  def turn_robot([a, b, c, d], 0), do: [d, a, b, c]
  def turn_robot([a, b, c, d], _), do: [b, c, d, a]
end
