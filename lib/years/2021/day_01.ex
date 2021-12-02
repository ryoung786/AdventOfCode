defmodule Aoc.Year2021.Day01 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> Input.to_int_list()
    |> num_increasing()
  end

  def part_two(input) do
    input
    |> Input.to_int_list()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> num_increasing()
  end

  def num_increasing(depths) do
    depths
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [prev_depth, next_depth] -> next_depth > prev_depth end)
  end
end
