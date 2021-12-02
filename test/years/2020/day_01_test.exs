defmodule Aoc.Year2020.Day01Test do
  use ExUnit.Case, async: true
  import Aoc.Year2020.Day01
  import Aoc.Utils.Input

  setup_all do
    input = ~w(1721 979 366 299 675 1456)
    {:ok, input: list_to_string(input)}
  end

  describe "2020 day 1" do
    test "part one", %{input: input} do
      assert part_one(input) == 514_579
    end

    test "part two", %{input: input} do
      assert part_two(input) == 241_861_950
    end
  end
end
