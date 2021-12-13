defmodule Aoc.Year2021.Day07Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day07

  setup_all do
    input = "16,1,2,0,4,2,7,1,2,14"

    {:ok, input: input}
  end

  describe "2021 Day 7" do
    test "part one", %{input: input} do
      assert part_one(input) == 37
    end

    test "part two", %{input: input} do
      assert part_two(input) == 168
    end
  end
end
