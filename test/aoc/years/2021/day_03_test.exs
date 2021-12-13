defmodule Aoc.Year2021.Day03Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day03

  setup_all do
    input = """
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    """

    {:ok, input: input}
  end

  describe "2021 Day 3" do
    test "part one", %{input: input} do
      assert part_one(input) == 198
    end

    test "part two", %{input: input} do
      assert part_two(input) == 230
    end
  end
end
