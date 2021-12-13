defmodule Aoc.Year2019.Day19 do
  use Aoc.DayBase
  # import Enum

  @impl true
  def part_one(str) do
    prog = str |> Input.to_intcode_program()

    gen_map(prog)
    |> Enum.filter(fn {y, _} -> y < 50 end)
    |> Enum.map(fn {_y, {xmin, xmax}} -> 1 + xmax - xmin end)
    |> Enum.sum()
  end

  @impl true
  def part_two(str) do
    {x, y} = str |> Input.to_intcode_program() |> get_sleigh_xy()
    10000 * x + y
  end

  def gen_map(prog) do
    1..1100
    |> Enum.reduce([{0, {0, 0}}], fn y, acc ->
      [{_y, {xmin, xmax}} | _] = acc
      new_xmin = xmin..(xmax + 1) |> Enum.find(fn x -> is_beam_at({x, y}, prog) end)
      new_xmax = (xmax + 1)..xmin |> Enum.find(fn x -> is_beam_at({x, y}, prog) end)

      if new_xmin == nil,
        do: acc,
        else: [{y, {new_xmin, new_xmax}} | acc]
    end)
    |> Map.new()
  end

  defp is_beam_at({x, y}, prog) do
    {:ok, vm} = Intcode.new(prog)
    Intcode.input(vm, [x, y])
    state = Intcode.run_sync(vm)
    state.output == [1]
  end

  def get_sleigh_xy(prog), do: get_sleigh_xy(prog, gen_map(prog))

  def get_sleigh_xy(_prog, map) do
    y =
      600..1100
      |> Enum.find(fn y ->
        {_, b} = Map.get(map, y - 99)
        {a, _} = Map.get(map, y)

        b - a >= 99
      end)

    {x, _} = Map.get(map, y)
    {x, y - 99}
  end
end
