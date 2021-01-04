defmodule Aoc.Days.D_03 do
  use Aoc.Days.Base

  def parse_input_str(str), do: str |> Util.str_array()

  @impl true
  def part_one(str) do
    arr = parse_input_str(str)
    {"Tree collisions:", count_collisions_with_slope(arr, 1, 3)}
  end

  @impl true
  def part_two(str) do
    arr = parse_input_str(str)

    product =
      [
        count_collisions_with_slope(arr, 1, 1),
        count_collisions_with_slope(arr, 1, 3),
        count_collisions_with_slope(arr, 1, 5),
        count_collisions_with_slope(arr, 1, 7),
        count_collisions_with_slope(arr, 2, 1)
      ]
      |> Enum.reduce(fn x, acc -> x * acc end)

    {"Tree collisions:", product}
  end

  @spec count_collisions_with_slope(list(String.t()), integer(), integer()) :: integer()
  def count_collisions_with_slope(arr, dy, dx) do
    arr
    |> Enum.take_every(dy)
    |> Enum.with_index()
    |> Enum.count(fn {row_str, r} ->
      i = rem(r * dx, String.length(row_str))
      String.at(row_str, i) == "#"
    end)
  end
end
