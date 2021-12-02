defmodule Aoc.Year2020.Day03 do
  use Aoc.DayBase

  def part_one(input) do
    trees = input |> Input.to_str_list()
    num_tree_collisions(trees, {3, 1})
  end

  def part_two(input) do
    trees = input |> Input.to_str_list()

    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn slope -> num_tree_collisions(trees, slope) end)
    |> Enum.product()
  end

  defp num_tree_collisions([top | _] = trees, {dx, dy} = _slope) do
    width = String.length(top)

    trees
    |> Enum.take_every(dy)
    |> Enum.with_index()
    |> Enum.count(fn {row, i} ->
      String.at(row, rem(i * dx, width)) == "#"
    end)
  end
end
