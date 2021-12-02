defmodule Aoc.Year2019.Day17 do
  use Aoc.DayBase
  # import Enum

  @impl true
  def part_one(str) do
    str |> Input.to_intcode_program()
    1
  end

  @impl true
  def part_two(_str) do
    3
  end
end
