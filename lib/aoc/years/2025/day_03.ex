defmodule Aoc.Year2025.Day03 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> parse()
    |> Enum.sum_by(&joltage(&1, 2))
  end

  def part_two(input) do
    input
    |> parse()
    |> Enum.sum_by(&joltage(&1, 12))
  end

  def parse(input) do
    input |> Input.to_int_list() |> Enum.map(&Integer.digits/1)
  end

  def joltage(batteries, chunk) do
    batteries
    |> Enum.chunk_every(chunk, 1, :discard)
    |> Enum.reduce(fn curr, highs ->
      zipped = Enum.zip(curr, highs)
      i = Enum.find_index(zipped, fn {a, b} -> a > b end) || 999

      {left, _} = Enum.split(highs, i)
      {_, right} = Enum.split(curr, i)
      left ++ right
    end)
    |> Integer.undigits()
  end
end
