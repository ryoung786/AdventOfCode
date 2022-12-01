defmodule Aoc.Year2022.Day01 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
    |> Enum.max()
  end

  def part_two(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.sum()
  end
end
