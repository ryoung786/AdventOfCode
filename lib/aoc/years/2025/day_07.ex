defmodule Aoc.Year2025.Day07 do
  use Aoc.DayBase
  alias Aoc.Utils.Grid

  def part_one(input) do
    g = Grid.new(input)
    {{sx, sy}, _} = Enum.find(g, fn {_xy, v} -> v == "S" end)

    process = fn [{x, y} = xy | rest], splits, seen ->
      cond do
        xy in seen -> {rest, splits, seen}
        g[xy] == nil -> {rest, splits, [xy | seen]}
        g[xy] == "." -> {[{x, y + 1} | rest], splits, [xy | seen]}
        g[xy] == "^" -> {[{x - 1, y}, {x + 1, y} | rest], [xy | splits], [xy | seen]}
      end
    end

    {_, splits, _} =
      Enum.reduce_while(0..9_999, {[{sx, sy + 1}], [], []}, fn
        _, {[], splits, _} -> {:halt, {nil, splits, nil}}
        _, {queue, splits, seen} -> {:cont, process.(queue, splits, seen)}
      end)

    splits |> Enum.uniq() |> Enum.count()
  end

  def part_two(input) do
    g = Grid.new(input)
    {{x, y}, _} = Enum.find(g, fn {_xy, v} -> v == "S" end)
    timelines(g, {x, y + 1})
  end

  def timelines(g, {x, y} = xy) do
    cond do
      Process.get(xy) ->
        Process.get(xy)

      g[xy] == nil ->
        Process.put(xy, 1)
        1

      g[xy] == "." ->
        val = timelines(g, {x, y + 1})
        Process.put(xy, val)
        val

      g[xy] == "^" ->
        val = timelines(g, {x - 1, y}) + timelines(g, {x + 1, y})
        Process.put(xy, val)
        val
    end
  end

  def example() do
    """
    .......S.......
    ...............
    .......^.......
    ...............
    ......^.^......
    ...............
    .....^.^.^.....
    ...............
    ....^.^...^....
    ...............
    ...^.^...^.^...
    ...............
    ..^...^.....^..
    ...............
    .^.^.^.^.^...^.
    ...............
    """
    |> String.trim()
  end
end
