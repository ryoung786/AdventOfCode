defmodule Aoc.Year2020.Day06 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&sum_any/1)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&sum_all/1)
    |> Enum.sum()
  end

  defp sum_any(group) do
    group
    |> all_answers()
    |> Enum.uniq()
    |> Enum.count()
  end

  defp sum_all(group) do
    group_size = group |> String.split("\n", trim: true) |> Enum.count()

    group
    |> all_answers()
    |> Enum.frequencies()
    |> Enum.count(fn {_k, v} -> v == group_size end)
  end

  defp all_answers(group) do
    group
    |> String.replace(~r/\s+/, "")
    |> String.graphemes()
  end
end
