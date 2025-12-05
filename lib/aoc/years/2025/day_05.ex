defmodule Aoc.Year2025.Day05 do
  use Aoc.DayBase

  def part_one(input) do
    {ranges, available} = input |> parse()
    ranges = Enum.map(ranges, fn {a, b} -> a..b end)

    Enum.count(available, fn ingredient ->
      Enum.any?(ranges, &(ingredient in &1))
    end)
  end

  def part_two(input) do
    {ranges, _} = input |> parse()
    [initial | _] = ranges = Enum.sort(ranges)

    Enum.reduce(ranges, [initial], fn {a, b}, all ->
      [{low, high} | rest] = all

      if a > high,
        do: [{a, b} | all],
        else: [{low, max(high, b)} | rest]
    end)
    |> Enum.sum_by(fn {a, b} -> b - a + 1 end)
  end

  def parse(input) do
    [ranges, available] = input |> String.split("\n\n")

    ranges =
      ranges
      |> String.split("\n")
      |> Enum.map(fn range ->
        [[_, a, b]] = Regex.scan(~r/(\d+)-(\d+)/, range)
        {String.to_integer(a), String.to_integer(b)}
      end)

    available = Input.to_int_list(available)
    {ranges, available}
  end

  def example() do
    """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """
    |> String.trim()
  end
end
