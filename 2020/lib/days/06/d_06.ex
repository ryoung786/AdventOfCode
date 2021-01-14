defmodule Aoc2020.Days.D_06 do
  use Aoc2020.Days.Base

  defp parse_input_str(str), do: str |> String.split("\n\n")

  @impl true
  def part_one(str),
    do: {"Part one:", str |> parse_input_str() |> Enum.map(&sum_any/1) |> Enum.sum()}

  @impl true
  def part_two(str),
    do: {"Part two:", str |> parse_input_str() |> Enum.map(&sum_all/1) |> Enum.sum()}

  def sum_any(group), do: group |> all_answers() |> Enum.uniq() |> Enum.count()

  def sum_all(group) do
    group_size = group |> String.split("\n", trim: true) |> Enum.count()

    group
    |> all_answers()
    |> Enum.frequencies()
    |> Enum.count(fn {_k, v} -> v == group_size end)
  end

  def all_answers(group), do: group |> String.replace(~r/\s/, "") |> String.graphemes()
end
