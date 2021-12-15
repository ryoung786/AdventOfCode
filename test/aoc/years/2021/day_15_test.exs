defmodule Aoc.Year2021.Day15Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day15

  setup_all do
    input = """
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
    """

    {:ok, input: input}
  end

  describe "2021 Day 15" do
    test "part one", %{input: input} do
      assert part_one(input) == 40
    end

    test "part two", %{input: input} do
      assert part_two(input) == 315
    end
  end
end
