defmodule Aoc.Year2021.Day10Test do
  use ExUnit.Case, async: true
  import Aoc.Year2021.Day10

  setup_all do
    input = """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """

    {:ok, input: input}
  end

  describe "2021 Day 10" do
    test "part one", %{input: input} do
      assert part_one(input) == 26397
    end

    test "part two", %{input: input} do
      assert part_two(input) == 288_957
    end
  end
end
