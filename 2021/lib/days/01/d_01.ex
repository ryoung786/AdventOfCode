defmodule Aoc2021.Days.D_01 do
  use Aoc2021.Days.Base

  defp parse_input_str(str), do: str |> Util.int_array()

  @impl true
  def part_one(str) do
    arr = parse_input_str(str)
    {"Part one:", num_increasing(arr)}
  end

  @impl true
  def part_two(str) do
    arr = parse_input_str(str)
    {"Part two:", num_increasing_sweep(arr)}
  end

  def num_increasing(arr) do
    arr
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [prev_depth, next_depth] -> next_depth > prev_depth end)
  end

  def num_increasing_sweep(arr) do
    arr
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> num_increasing()
  end
end
