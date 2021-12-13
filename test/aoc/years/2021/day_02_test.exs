defmodule Aoc.Year2021.Day02Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day02

  setup_all do
    input = """
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """

    {:ok, input: input}
  end

  describe "2021 Day 2" do
    test "part one", %{input: input} do
      assert part_one(input) == 150
    end

    test "part two", %{input: input} do
      assert part_two(input) == 900
    end
  end
end
