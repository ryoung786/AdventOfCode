defmodule Aoc.Year2020.Day01 do
  use Aoc.DayBase

  def part_one(input) do
    {a, b} = input |> Input.to_int_list() |> find_pair(2020)
    a * b
  end

  def part_two(input) do
    entries = input |> Input.to_int_list()

    {a, b} = entries |> Enum.find_value(&find_pair(entries, 2020 - &1))

    a * b * (2020 - a - b)
  end

  def find_pair(lst, target_sum) do
    case Enum.find(lst, fn n -> (target_sum - n) in lst end) do
      nil -> nil
      val -> {val, target_sum - val}
    end
  end
end
