defmodule Aoc.Year2020.Day10 do
  use Aoc.DayBase
  use Agent

  defp parse_input_str(str), do: str |> Input.to_int_list() |> bookend()

  @impl true
  def part_one(str) do
    %{1 => single, 3 => triple} =
      str
      |> parse_input_str()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)
      |> Enum.frequencies()

    single * triple
  end

  @impl true
  def part_two(str),
    do: str |> parse_input_str() |> count_arrangements()

  def bookend(arr) do
    arr = Enum.sort(arr)
    max = List.last(arr)
    [0 | arr] ++ [max + 3]
  end

  def count_arrangements([_]), do: 1

  def count_arrangements(all) do
    case Process.get(all) do
      nil -> work_and_memoize(all)
      x -> x
    end
  end

  defp work_and_memoize([a | arr] = all) do
    sum =
      1..3
      |> Enum.map(&h(a + &1, arr))
      |> Enum.filter(&(!Enum.empty?(&1)))
      |> Enum.map(&count_arrangements/1)
      |> Enum.sum()

    Process.put(all, sum)
    sum
  end

  def h(x, arr),
    do: if(x in arr, do: Enum.drop_while(arr, &(&1 < x)), else: [])
end
