defmodule Aoc.Year2021.Day09Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day09

  setup_all do
    input = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """

    {:ok, input: input}
  end

  describe "2021 Day 9" do
    test "part one", %{input: input} do
      assert part_one(input) == 15
    end

    test "part two", %{input: input} do
      assert part_two(input) == 1134
    end
  end
end
