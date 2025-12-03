defmodule Aoc.Year2025.Day03 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> parse()
    |> Enum.sum_by(&joltage/1)
  end

  def part_two(input) do
    input
    |> parse()
    |> Enum.sum_by(&joltage_12/1)
  end

  def parse(input) do
    input |> Input.to_int_list() |> Enum.map(&Integer.digits/1)
  end

  def joltage(batteries) do
    batteries
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce([0, 0], fn [a, b], [high_a, high_b] ->
      cond do
        a > high_a -> [a, b]
        b > high_b -> [high_a, b]
        true -> [high_a, high_b]
      end
    end)
    |> Integer.undigits()
  end

  def joltage_12(batteries) do
    highs = for _ <- 1..12, do: 0

    batteries
    |> Enum.chunk_every(12, 1, :discard)
    |> Enum.reduce(highs, fn curr, highs ->
      i =
        Enum.find_index(Enum.zip(curr, highs), fn {a, b} ->
          a > b
        end) || 99_999_999_999_999

      {left, _} = Enum.split(highs, i)
      {_, right} = Enum.split(curr, i)
      left ++ right
    end)
    |> Integer.undigits()
  end
end
