defmodule Aoc.Year2025.Day04 do
  use Aoc.DayBase
  alias Aoc.Utils.Grid

  def part_one(input) do
    g = Grid.new(input)
    Enum.count(g, fn {xy, v} -> v == "@" && adjacent_paper_count(g, xy) < 4 end)
  end

  def part_two(input) do
    g = Grid.new(input)

    remove_paper =
      &Map.new(&1, fn {xy, v} ->
        if v == "@" && adjacent_paper_count(&1, xy) < 4, do: {xy, "."}, else: {xy, v}
      end)

    final_grid =
      Enum.reduce_while(0..99, g, fn _step, g ->
        new = remove_paper.(g)
        if new == g, do: {:halt, new}, else: {:cont, new}
      end)

    paper_count(g) - Enum.count(final_grid, fn {_xy, v} -> v == "@" end)
  end

  def paper_count(map), do: map |> Map.values() |> Enum.count(&(&1 == "@"))

  def adjacent_paper_count(g, xy) do
    Grid.neighbors(g, xy) |> paper_count()
  end

  def example() do
    """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """
    |> String.trim()
  end
end
