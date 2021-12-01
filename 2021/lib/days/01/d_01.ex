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
    |> Enum.reduce({0, 999_999_999}, fn depth, {count, prev_depth} ->
      if depth > prev_depth, do: {count + 1, depth}, else: {count, depth}
    end)
    |> elem(0)
  end

  def num_increasing_sweep(arr) do
    arr
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> num_increasing()
  end

  def pair_that_sums_to_target(arr, target) do
    lookup = Map.new(arr, fn x -> {x, true} end)

    case Enum.find(arr, fn x -> lookup[target - x] end) do
      nil -> nil
      found -> {found, target - found}
    end
  end

  def trio_that_sums_to_target(arr, target) do
    {found, i} =
      arr
      |> Enum.with_index()
      |> Enum.find(fn {x, i} ->
        Enum.slice(arr, i..-1)
        |> pair_that_sums_to_target(target - x)
      end)

    {a, b} = Enum.slice(arr, i..-1) |> pair_that_sums_to_target(target - found)
    {found, a, b}
  end
end
