defmodule Aoc.Year2025.Day02 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> parse_input()
    |> Enum.sum_by(fn range ->
      range |> Enum.filter(&invalid?/1) |> Enum.sum()
    end)
  end

  def part_two(input) do
    input
    |> parse_input()
    |> Enum.sum_by(fn range ->
      range |> Enum.filter(&invalid2?/1) |> Enum.sum()
    end)
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn str ->
      [a, b] = str |> String.split("-") |> Enum.map(&String.to_integer/1)
      a..b
    end)
  end

  defp invalid?(n) do
    digits = Integer.digits(n)
    {a, b} = Enum.split(digits, div(length(digits), 2))
    a == b
  end

  def invalid2?(n) when n < 10, do: false

  def invalid2?(n) do
    digits = Integer.digits(n)

    Enum.any?(1..div(length(digits), 2), fn size ->
      [a | _] = chunks = Enum.chunk_every(digits, size)
      Enum.all?(chunks, fn chunk -> chunk == a end)
    end)
  end
end
