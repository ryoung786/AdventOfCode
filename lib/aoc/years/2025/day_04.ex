defmodule Aoc.Year2025.Day04 do
  use Aoc.DayBase
  alias Aoc.Utils.Matrix

  def part_one(input) do
    m = Matrix.from_string(input, & &1)
    Matrix.count(m, fn x, y, v -> v == "@" && adjacent_paper_count(m, x, y) < 4 end)
  end

  def part_two(input) do
    m = Matrix.from_string(input, & &1)
    num_at_start = Matrix.count(m, fn _, _, v -> v == "@" end)

    final_m =
      Enum.reduce_while(0..99, m, fn _step, m ->
        new = remove_paper(m)
        if new == m, do: {:halt, new}, else: {:cont, new}
      end)

    num_at_start - Matrix.count(final_m, fn _, _, v -> v == "@" end)
  end

  def remove_paper(m) do
    m
    |> Matrix.with_xy()
    |> Matrix.map(fn {{x, y}, v} ->
      if v == "@" && adjacent_paper_count(m, x, y) < 4, do: ".", else: v
    end)
  end

  def adjacent_paper_count(m, x, y) do
    Matrix.all_neighbors(m, x, y) |> Map.values() |> Enum.count(&(&1 == "@"))
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
