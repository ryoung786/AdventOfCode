defmodule Aoc.Year2021.Day11Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day11

  setup_all do
    input = """
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    """

    {:ok, input: input}
  end

  describe "2021 Day 11" do
    test "part one", %{input: input} do
      assert part_one(input) == 1656
    end

    test "part two", %{input: input} do
      assert part_two(input) == 195
    end
  end
end
