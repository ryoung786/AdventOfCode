defmodule Aoc.Year2021.Day01Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day01
  import Aoc.Utils.Input

  setup_all do
    input = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
    {:ok, input: list_to_string(input)}
  end

  test "part one", %{input: input} do
    assert part_one(input) == 7
  end

  test "part two", %{input: input} do
    assert part_two(input) == 5
  end
end
