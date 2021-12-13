defmodule Aoc.Year2021.Day06Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day06

  setup_all do
    input = "3,4,3,1,2"

    {:ok, input: input}
  end

  describe "2021 Day 6" do
    test "part one", %{input: input} do
      assert part_one(input) == 5934
    end

    test "part two", %{input: input} do
      assert part_two(input) == 26_984_457_539
    end
  end
end
