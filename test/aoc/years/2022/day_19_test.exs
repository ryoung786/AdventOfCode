defmodule Aoc.Year2022.Day19Test do
  use ExUnit.Case, async: true
  import Aoc.Year2022.Day19

  setup_all do
    input = """

    """

    {:ok, input: input}
  end

  describe "2022 Day 19" do
    test "part one", %{input: input} do
      assert part_one(input) == :todo
    end

    # test "part two", %{input: input} do
    #   assert part_two(input) == :todo
    # end
  end
end
