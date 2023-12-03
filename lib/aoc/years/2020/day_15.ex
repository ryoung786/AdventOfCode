defmodule Aoc.Year2020.Day15 do
  use Aoc.DayBase

  def parse_input(str), do: str |> String.split(",") |> Enum.map(&String.to_integer/1)

  @impl true
  def part_one(str), do: str |> parse_input |> calc(2020)

  @impl true
  def part_two(str), do: str |> parse_input |> calc(30_000_000)

  def calc(input_arr, target) do
    {last_num_spoken, nums} = List.pop_at(input_arr, -1)
    history = nums |> Enum.with_index(1) |> Enum.into(%{})

    (Enum.count(input_arr) + 1)..target
    |> Enum.reduce({history, last_num_spoken}, fn i, {history, prev} ->
      curr =
        case Map.get(history, prev) do
          nil -> 0
          n -> i - 1 - n
        end

      {Map.put(history, prev, i - 1), curr}
    end)
    |> elem(1)
  end
end
