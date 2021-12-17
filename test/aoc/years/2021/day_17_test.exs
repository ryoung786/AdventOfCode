defmodule Aoc.Year2021.Day17Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day17

  setup_all do
    input = """
    target area: x=20..30, y=-10..-5
    """

    {:ok, input: input}
  end

  describe "2021 Day 17" do
    test "part one", %{input: input} do
      assert part_one(input) == 45
    end

    test "part two", %{input: input} do
      assert part_two(input) == 112
    end
  end
end
