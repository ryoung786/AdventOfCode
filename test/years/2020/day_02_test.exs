defmodule Aoc.Year2020.Day02Test do
  use ExUnit.Case, async: true
  import Aoc.Year2020.Day02

  setup_all do
    input = """
       1-3 a: abcde
       1-3 b: cdefg
       2-9 c: ccccccccc
    """

    {:ok, input: input}
  end

  describe "2020 day 2" do
    test "part one", %{input: input} do
      assert part_one(input) == 2
    end

    test "part two", %{input: input} do
      assert part_two(input) == 1
    end
  end
end
