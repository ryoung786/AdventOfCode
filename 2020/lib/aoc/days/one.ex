defmodule Aoc.Days.One do
  alias Aoc.Util

  def process() do
    arr =
      Util.read_file("01_a.input")
      |> Enum.map(&String.to_integer/1)

    {a, b} = pair_that_sums_to_target(arr, 2020)
    {x, y, z} = trio_that_sums_to_target(arr, 2020)
    {{a * b, a, b}, {x * y * z, x, y, z}}
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
