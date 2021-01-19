defmodule Aoc2019.Days.D_17 do
  use Aoc2019.Days.Base
  # import Enum

  @impl true
  def part_one(str) do
    str |> Util.to_intcode_program()
    1
  end

  @impl true
  def part_two(_str) do
    3
  end
end
