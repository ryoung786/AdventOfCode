defmodule Aoc.Year2021.Day14Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day14

  setup_all do
    input = """
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """

    {:ok, input: input}
  end

  describe "2021 Day 14" do
    test "part one", %{input: input} do
      assert part_one(input) == 1588
    end

    # test "part two", %{input: input} do
    #   assert part_two(input) == 2_188_189_693_529
    # end
  end
end
