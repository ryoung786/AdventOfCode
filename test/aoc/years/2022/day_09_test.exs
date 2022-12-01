defmodule Aoc.Year2022.Day09Test do
  use ExUnit.Case, async: true
  import Aoc.Year2022.Day09

  setup_all do
    input = """

    """

    {:ok, input: input}
  end

  describe "2022 Day 09" do
    test "part one", %{input: input} do
      assert part_one(input) == :todo
    end

    # test "part two", %{input: input} do
    #   assert part_two(input) == :todo
    # end
  end
end
