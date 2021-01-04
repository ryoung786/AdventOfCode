defmodule Aoc.Days.D_01 do
  use Aoc.Days.Base

  defp parse_input_str(str), do: str |> Util.int_array()

  @impl true
  def part_one(str) do
    arr = parse_input_str(str)
    {a, b} = pair_that_sums_to_target(arr, 2020)
    {"Part one:", "#{a} * #{b} = #{a * b}"}
  end

  @impl true
  def part_two(str) do
    arr = parse_input_str(str)
    {x, y, z} = trio_that_sums_to_target(arr, 2020)
    {"Part two:", "#{x} * #{y} * #{z} = #{x * y * z}"}
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
