defmodule Aoc.Year2021.Day05Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day05

  setup_all do
    input = """
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
    """

    {:ok, input: input}
  end

  describe "2021 Day 5" do
    test "part one", %{input: input} do
      assert part_one(input) == 5
    end

    test "part two", %{input: input} do
      assert part_two(input) == 12
    end
  end
end
