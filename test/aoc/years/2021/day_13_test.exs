defmodule Aoc.Year2021.Day13Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day13

  setup_all do
    input = """
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
    """

    {:ok, input: input}
  end

  describe "2021 Day 13" do
    test "part one", %{input: input} do
      assert part_one(input) == 17
    end
  end
end
