defmodule Aoc.Year2020.Day05Test do
  use ExUnit.Case, async: true
  import Aoc.Year2020.Day05
  import Aoc.Utils.Input

  setup_all do
    input = ~w(BFFFBBFRRR FFFBBBFRRR BBFFBBFRLL)
    {:ok, input: list_to_string(input)}
  end

  describe "2020 day 5" do
    test "part one", %{input: input} do
      assert part_one(input) == 820
    end
  end
end
