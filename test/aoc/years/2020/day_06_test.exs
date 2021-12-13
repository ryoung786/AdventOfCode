defmodule Aoc.Year2020.Day06Test do
  use ExUnit.Case, async: true
  import Aoc.Year2020.Day06

  setup_all do
    input = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    {:ok, input: input}
  end

  describe "2020 day 6" do
    test "part one", %{input: input} do
      assert part_one(input) == 11
    end

    test "part two", %{input: input} do
      assert part_two(input) == 6
    end
  end
end
