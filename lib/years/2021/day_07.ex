defmodule Aoc.Year2021.Day07 do
  use Aoc.DayBase

  def part_one(input) do
    input
    |> parse_input()
    |> min_fuel(fn steps -> steps end)
  end

  def part_two(input) do
    input
    |> parse_input()
    |> min_fuel(fn steps -> Enum.sum(0..steps) end)
  end

  def parse_input(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def min_fuel(crab_positions, fuel_cost) do
    freqs = crab_positions |> Enum.frequencies()

    0..Enum.max(crab_positions)
    |> Enum.map(fn n ->
      Enum.reduce(freqs, 0, fn {pos, num_crabs}, acc ->
        acc + fuel_cost.(abs(pos - n)) * num_crabs
      end)
    end)
    |> Enum.min()
  end
end
