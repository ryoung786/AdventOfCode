defmodule Aoc.Year2019.Day01 do
  use Aoc.DayBase
  import Enum

  @impl true
  def part_one(str) do
    str
    |> Input.to_int_list()
    |> map(&fuel_required/1)
    |> sum()
  end

  @impl true
  def part_two(str) do
    str
    |> Input.to_int_list()
    |> map(&fuel_required_recursive/1)
    |> sum()
  end

  def fuel_required(mass) do
    [0, mass |> Kernel./(3) |> floor() |> Kernel.-(2)] |> max()
  end

  def fuel_required_recursive(0), do: 0

  def fuel_required_recursive(mass) do
    fuel = fuel_required(mass)
    fuel + fuel_required_recursive(fuel)
  end
end
