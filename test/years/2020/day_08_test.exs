defmodule Aoc.Year2020.Day08Test do
  use ExUnit.Case, async: true
  import Aoc.Year2020.Day08

  setup_all do
    input = """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    """

    {:ok, input: input}
  end

  describe "2020 day 8" do
    test "part one", %{input: input} do
      assert part_one(input) == 5
    end

    test "part two", %{input: input} do
      assert part_two(input) == 8
    end
  end
end
