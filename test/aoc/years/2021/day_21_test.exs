defmodule Aoc.Year2021.Day21Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day21

  setup_all do
    input = """
    Player 1 starting position: 4
    Player 2 starting position: 8
    """

    {:ok, input: input}
  end

  describe "2021 Day 21" do
    test "part one", %{input: input} do
      assert part_one(input) == 739_785
    end

    # test "part two", %{input: input} do
    #   assert part_two(input) == :todo
    # end
  end
end
