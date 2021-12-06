defmodule Aoc.Year2021.Day06 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> to_school()
    |> run_for_days(80)
    |> Enum.count()
  end

  def part_two(input) do
    lookup = precompute_128days()

    input
    |> to_school()
    |> run_for_days(128)
    |> Enum.map(&lookup[&1])
    |> Enum.sum()
  end

  def to_school(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def run_for_days(school, n) do
    Enum.reduce(1..n, school, &next_day/2)
  end

  def next_day(_day_num, school) do
    Enum.reduce(school, [], fn
      0, new_school -> [6, 8] ++ new_school
      n, new_school -> [n - 1 | new_school]
    end)
  end

  def precompute_128days() do
    0..8
    |> Enum.map(fn n -> {n, run_for_days([n], 128) |> Enum.count()} end)
    |> Enum.into(%{})
  end
end
